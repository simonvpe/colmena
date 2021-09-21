{ pkgs, lib, config, ... }:
let
  cfg = config.services.ssh-agent;
  inherit (pkgs) writeScript coreutils openssh bash;
  inherit (lib) mkEnableOption mkOption mkIf types concatStringsSep mkMerge;
  inherit (types) listOf str bool either enum;
  flip = fn: lhs: rhs: fn rhs lhs;
  SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/ssh-agent.socket";
in
{
  options = {
    services.ssh-agent.enable = mkEnableOption "ssh-agent";

    services.ssh-agent.keyFiles = mkOption {
      type = listOf str;
    };

    services.ssh-agent.bashIntegration = mkOption {
      type = bool;
      default = true;
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      systemd.user.services.ssh-agent = {
        Unit = {
          After = [ "networking.target" ];
        };
        Service = {
          Type = "exec";
          Environment = "SSH_AUTH_SOCK=%t/ssh-agent.socket";
          ExecStart = "${openssh}/bin/ssh-agent -D -a $SSH_AUTH_SOCK";
          ExecStartPost =
            let
              ask-pass = input: writeScript "askpass" ''
                readonly input=${input}
                readonly pasfile="''${input%%:*}"
                readonly keyfile="''${input##*:}"
                [[ "$pasfile" != "$keyfile" ]] && ${coreutils}/bin/cat "$pasfile" || true
              '';
              parts = flip map cfg.keyFiles (input:
                builtins.toString (writeScript "ssh-add" ''
                  readonly input=${input}
                  readonly keyfile="''${input##*:}"
                  export SSH_ASKPASS=${ask-pass input}
                  ${openssh}/bin/ssh-add "$keyfile"
                ''));
              script = writeScript "ssh-add" ''
                #!${bash}/bin/bash
                ${concatStringsSep "\n" parts}
              '';
            in
            builtins.toString script;

        };
        Install = {
          WantedBy = [ "multi-user.target" ];
        };
      };

      pam.sessionVariables = { inherit SSH_AUTH_SOCK; };
    })
    (mkIf (cfg.enable && cfg.bashIntegration) {
      # TODO: not sure about ~/.profile ~/.pam-environment ~/.bashrc
      programs.bash.sessionVariables = { inherit SSH_AUTH_SOCK; };
      programs.bash.bashrcExtra = ''export SSH_AUTH_SOCK="${SSH_AUTH_SOCK}"'';
    })
  ];
}
