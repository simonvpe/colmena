{ config
, pkgs
, lib
, ...
}:
let
  inherit (lib) mkEnableOption mkOption mkIf genAttrs mkMerge mapAttrs concatLists last toList imap optionalString mkDefault;
  inherit (lib.types) listOf str submodule attrsOf int bool ints;
  inherit (pkgs) openfortivpn systemd bash writeScript crudini writeText;
  inherit (builtins) toString;

  servicename = "openfortivpn@";

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

  template = {
    services."${servicename}" = {
      serviceConfig = {
        Type = "exec";
        Restart = "always";
        ExecStart = writeScript "openfortivpn" ''
          #!${bash}/bin/bash
          ${openfortivpn}/bin/openfortivpn -c $CONFIG >&2
        '';
      };
    };
  };

  mkServiceConf = i: args@{ enable, ... }:
    let
      mkOverrideConf = args:
        let
          disable-dnssec = args.use-resolvconf && config.networking.useNetworkd;
          defaultConfig = args: writeText "openfortivpn-default-config" ''
            host = ${args.host}
            port = ${toString args.port}
            username = ${args.username}
            password = ${args.password}
            use-resolvconf = ${if args.use-resolvconf then "1" else "0"}
          '';
          gen-config = writeScript "openfortivpn-generate-config" ''
            #!${bash}/bin/bash
            set -x
            install -m0600 ${defaultConfig args} $IFNAME
            ${crudini}/bin/crudini --merge $CONFIG "" <<< "pppd-ifname = $IFNAME"
            ${crudini}/bin/crudini --merge $CONFIG "" < ${args.configPath}
          '';
          resolvconf-hack = writeScript "openfortivpn-resolvconf-hack" ''
            #!${bash}/bin/bash
            set -x
            while ! test -d "/sys/class/net/$IFNAME"; do
              echo "waiting for $IFNAME" >&2
              sleep 1
            done
            ${systemd}/bin/resolvectl dnssec $IFNAME false
            ${systemd}/bin/resolvectl reset-server-features
          '';
        in
        writeText "override.conf" ''
          [Service]
          User=root
          PrivateTmp=no
          TimeoutSec=${toString args.timeout}
          Environment=IFNAME=${args.pppd-ifname}
          Environment=CONFIG=%t/openfortivpn-${toString i}.conf
          ExecStartPre=${gen-config}
          ExecStartPost=${optionalString disable-dnssec resolvconf-hack}
        '';
      mkSocketConf =
        writeText "${servicename}${toString i}.socket" ''
          [Socket]
          ListenStream=%t/${servicename}${toString i}.sock
        '';
    in
    mkIf enable {
      packages = toList (pkgs.runCommandNoCC "${servicename}${toString i}"
        {
          preferLocalBuild = true;
          allowSubstitutes = false;
        } ''
        mkdir -p $out/etc/systemd/system/ && cd $_
        ln -s /etc/systemd/system/${servicename}.service ${servicename}${toString i}.service
        ln -s ${mkSocketConf} ${servicename}${toString i}.socket
        mkdir -p ${servicename}${toString 1}.service.d && cd $_
        cp ${mkOverrideConf args} override.conf
      '');
      # targets.network-online.wants = [ "${servicename}${toString i}.service" ];
    };

  #mkUserServiceConfs = i: args: {
  #  user.services."openfortivpn-user-${toString i}" = {
  #    serviceConfig = rec {
  #      Type = "forking";
  #      # PIDFile = "$TMP/openfortivpn-${toString i}.pid";
  #      Environment = [
  #        "TMP=$XDG_RUNTIME_DIR";
  #        "SVC=${servicename}${toString i}.service"
  #      ];
  #      ExecStart = writeScript "openfortivpn-user-start" ''
  #        #!${bash}/bin/bash
  #        set -o errexit
  #        systemctl start $SVC
  #        systemctl show --property MainPID --value $SVC > ${PIDFile}
  #      '';
  #      ExecStop = "systemctl stop $SVC";
  #    };
  #  };
  #};

  mkPolkitRules =
    let fn = i: user: ''
      polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.systemd1.manage-units" &&
          action.lookup("unit") == "${servicename}${toString i}.service" &&
          subject.user == "${user}") {
            return polkit.Result.YES;
          }
      });
    '';
    in
    i: args: mkIf args.enable {
      extraConfig = toString (imap fn args.users);
    };
in
{
  inherit options;
  config.systemd = mkMerge (
    (imap mkServiceConf config.services.openfortivpn)
    #++ (imap mkUserServiceConfs config.services.openfortivpn)
    ++ toList template
  );
  config.security.polkit = mkMerge (imap mkPolkitRules config.services.openfortivpn);
}
