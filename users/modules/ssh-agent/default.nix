{ pkgs, lib, config, ... }:
let
  cfg = config.services.ssh-agent;
  inherit (pkgs) writeScript coreutils openssh bash;
  inherit (lib) mkEnableOption mkOption mkIf types concatStringsSep mkMerge splitString head last;
  inherit (types) listOf str bool either enum;
  flip = fn: lhs: rhs: fn rhs lhs;
  SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/ssh-agent.socket";
  sessionVariables = { inherit SSH_AUTH_SOCK; };
  initExtra = "export SSH_AUTH_SOCK='${SSH_AUTH_SOCK}'";
in
{
  options = {
    services.ssh-agent.enable = mkEnableOption "ssh-agent";

    services.ssh-agent.keyFiles = mkOption {
      type = listOf str;
    };
  };

  config = mkIf cfg.enable (mkMerge [{
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
            ask-pass = input:
              let
                pasfile = head (splitString ":" input);
                keyfile = last (splitString ":" input);
              in
              writeScript "askpass" ''
                [[ "${pasfile}" != "${keyfile}" ]] && ${coreutils}/bin/cat "${pasfile}" || true
              '';
            parts = flip map cfg.keyFiles (input:
              let keyfile = last (splitString ":" input);
              in
              builtins.toString (writeScript "ssh-add" ''
                export SSH_ASKPASS=${ask-pass input}
                ${openssh}/bin/ssh-add "${keyfile}"
              ''));
            script = writeScript "ssh-add" ''
              #!${bash}/bin/bash
              ${concatStringsSep "\n" parts}
            '';
          in
          builtins.toString script;

      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };

    home.sessionVariables = sessionVariables;
    xsession.initExtra = initExtra;
    programs.bash.initExtra = initExtra;
  }]);
}
