{ pkgs, lib, config, ... }:
let
  cfg = config.services.ssh-agent;
  debug = true;

  inherit (pkgs) writeScript coreutils openssh bash writeScriptBin;
  inherit (lib) mkEnableOption mkOption mkIf types concatStringsSep mkMerge pipe makeSearchPath mapAttrsToList flip;
  inherit (lib.strings) optionalString replaceStrings;
  inherit (lib.lists) toList;
  inherit (types) listOf str bool either enum;
  inherit (lib.lists) imap0;
  debugScript = optionalString debug "set -x";

  keyPassComboOption = types.submodule {
    options = {
      key = mkOption {
        type = types.str;
        default = null;
        description = "Path to the ssh private key file";
      };
      passphrase = mkOption {
        type = types.str;
        default = "";
        description = "Path to the passphrase to open the key";
      };
    };
  };

  options = {
    services.ssh-agent.enable = mkEnableOption "ssh-agent";

    services.ssh-agent.keys = mkOption {
      type = listOf keyPassComboOption;
      default = [ ];
      description = "Keys you want ssh agent to hold";
    };

    services.ssh-agent.uid = mkOption {
      type = types.int;
      description = "TODO: we should be able to figure this out without user specifying it";
    };

    services.ssh-agent.sshAuthSock = mkOption {
      type = types.str;
      default = "/run/user/${toString cfg.uid}/ssh-agent.socket";
      description = "The socket to reach ssh-agent";
    };
  };

  # Tricking ssh-add to work without an interactive password
  # prompt is a bit tricky. You need to set the SSH_ASKPASS
  # envvar to point to a script called when ssh-add wants a
  # password, but you can't pass any arguments to that script.
  # More weird is that ssh-add requireds DISPLAY to be set to
  # something or it will ask interactively in the tty.
  #
  # TODO: required in systemd? Additionally you need to pipe
  # /dev/null into ssh-askpass to make it believe it's not in
  # a tty

  ssh-askpass = writeScriptBin "ssh-askpass" ''
    #!${bash}/bin/bash
    # Usage: SSH_PASSFILE=<file> $0
    ${debugScript}
    chmod 0600 "$SSH_PASSFILE"
    exec cat "''${SSH_PASSFILE:-/dev/null}"
  '';

  ssh-add = writeScriptBin "ssh-add" ''
    #!${bash}/bin/bash
    # Usage: $0 <key-file> [<passphrase-file>]
    ${debugScript}
    set -o nounset -o errexit
    export SSH_PASSFILE="''${2:-/dev/null}"
    export SSH_ASKPASS="''${2:+${ssh-askpass}/bin/ssh-askpass}"
    export DISPLAY=/dev/null
    test -e ''${SSH_AUTH_SOCK?required}
    chmod 0600 "$1"
    ${openssh}/bin/ssh-add "$1" < /dev/null
  '';

  mapAttrsToEnvironmentList' = mapAttrsToList (key: val: "${key}=${val}");
  mapAttrsToEnvironmentList = as: mkMerge (map mapAttrsToEnvironmentList' (toList as));

  PATH = makeSearchPath "bin" [ openssh coreutils ];

  service = {
    Unit = {
      Requires = [ "age.service" "run-user-${toString cfg.uid}.mount" ];
      After = [ "age.service" "run-user-${toString cfg.uid}.mount" ];
    };
    Service = {
      Type = "exec";
      Environment = mapAttrsToEnvironmentList [
        { SSH_AUTH_SOCK = cfg.sshAuthSock; }
        { inherit PATH; }
      ];
      ExecStart = "${openssh}/bin/ssh-agent -D -a $SSH_AUTH_SOCK";
      ExecStartPost = map (x: "${ssh-add}/bin/ssh-add ${x.key} ${x.passphrase}") cfg.keys;
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
in
{
  inherit options;
  config = mkIf cfg.enable {
    systemd.user.services.ssh-agent = service;
    home.sessionVariables = { SSH_AUTH_SOCK = cfg.sshAuthSock; };
    xsession.initExtra = ''export SSH_AUTH_SOCK="${cfg.sshAuthSock}"'';
    programs.bash.initExtra = ''export SSH_AUTH_SOCK="${cfg.sshAuthSock}"'';
  };
}
