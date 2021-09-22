{ config
, pkgs
, lib
, ...
}:
let
  cfg = config.services.openfortivpn;
  inherit (lib) mkEnableOption mkOption mkIf genAttrs mkMerge mapAttrs concatLists last toList imap optionalString mkDefault;
  inherit (lib.types) listOf str submodule attrsOf int bool ints;
  inherit (pkgs) openfortivpn systemd bash writeScript crudini writeText coreutils;
  inherit (builtins) toString replaceStrings;

  servicename = i: "openfortivpn-${toString i}";

  openfortivpnOptions = { ... }: {
    options = {

      enable = mkEnableOption "openfortivpn";

      users = mkOption {
        type = listOf str;
        description = ''
          Start the service when one of the given users log in.
        '';
        default = [ ];
      };

      configPath = mkOption {
        type = str;
        description = ''
          A path on disk containing a configuration file. This will override any of the
          options. Use this to point to a config with your secret password and hostname.
        '';
        default = "/dev/null";
      };

      host = mkOption {
        type = str;
        default = "hostname";
        description = "The hostname of the forti VPN server";
      };

      port = mkOption {
        type = ints.positive;
        default = 443;
      };

      username = mkOption {
        type = str;
        default = "username";
      };

      password = mkOption {
        type = str;
        default = "password";
      };

      pppd-ifname = mkOption {
        type = str;
        default = "pppd%i";
      };

      use-resolvconf = mkOption {
        type = bool;
        default = true;
        description = "If possible use resolvconf to update /etc/resolv.conf";
      };

      timeout = mkOption {
        type = ints.unsigned;
        description = "Timeout";
        default = 20;
      };
    };
  };

  options.services.openfortivpn = mkOption {
    type = listOf
      (submodule [ openfortivpnOptions ]);
    default = [ ];
  };

  mkServices =
    let
      fn = i: args:
        let
          ifname = replaceStrings [ "%i" ] [ (toString i) ] args.pppd-ifname;
          disable-dnssec = args.use-resolvconf && config.networking.useNetworkd;
          defaultConfig = writeText "openfortivpn-default-config " ''
            host = ${args.host}
            port = ${toString args.port}
            username = ${args.username}
            password = ${args.password}
            use-resolvconf = ${if args.use-resolvconf then "1" else "0"}
            pppd-ifname = ${ifname}
          '';
          gen-config = writeScript "openfortivpn-generate-config " ''
            #!${bash}/bin/bash
            set -x
            install -m0600 ${defaultConfig} $CONFIG
            ${crudini}/bin/crudini --merge $CONFIG "" < ${args.configPath}
          '';
          resolvconf-hack = writeScript "openfortivpn-resolvconf-hack" ''
            #!${bash}/bin/bash
            set -x
            while ! test -d "/sys/class/net/${ifname}"; do
              echo "waiting for ${ifname}" >&2
              sleep 1
            done
            ${systemd}/bin/resolvectl dnssec ${ifname} false
            ${systemd}/bin/resolvectl reset-server-features
          '';
        in
        {
          services."${servicename i}" = {
            reloadIfChanged = false;
            serviceConfig = {
              Type = "exec";
              TimeoutSec = toString args.timeout;
              Environment = [ "CONFIG=%t/${servicename i}.conf" ];
              ExecStartPre = gen-config;
              ExecStart = "${openfortivpn}/bin/openfortivpn -c $CONFIG";
              ExecStartPost = optionalString disable-dnssec resolvconf-hack;
            };
          };
        };
    in
    imap fn;

  mkPolkitRules =
    let
      polkitConfig = i: user: {
        extraConfig = ''
          polkit.addRule(function(action, subject) {
            if (action.id == "org.freedesktop.systemd1.manage-units" &&
              action.lookup("unit") == "${servicename i}.service" &&
              subject.user == "${user}") {
                return polkit.Result.YES;
              }
          });
        '';
      };
      fn = i: { enable, users, ... }: mkIf enable (mkMerge (map (polkitConfig i) users));
    in
    imap fn;

  mkHomeManagerActivations =
    let
      hmConfig = i: user: {
        ${user}.systemd.user.services."${servicename i}" = {
          Service = {
            Type = "exec";
            Restart = "always";
            Environment = [ "PATH=${systemd}/bin:${coreutils}/bin" ];
            ExecStart = toString (writeScript "openfortivpn-user-start" ''
              #!${bash}/bin/bash
              set -o errexit
              systemctl start ${servicename i}
              while [[ "$(systemctl show --property MainPID --value ${servicename i}.service)" > 0 ]]; do
                echo openfortivpn is alive >&2
                sleep 1
              done
            '');
            ExecStop = "systemctl stop ${servicename i}";
          };
          Install = {
            WantedBy = [ "default.target" ];
          };
        };
      };
      fn = i: { users, enable, ... }: mkIf enable (mkMerge (map (hmConfig i) users));
    in
    imap fn;

in
{
  inherit options;
  config.systemd = mkMerge (mkServices cfg);
  config.home-manager.users = mkMerge (mkHomeManagerActivations cfg);
  config.security.polkit = mkMerge (mkPolkitRules cfg);
}
