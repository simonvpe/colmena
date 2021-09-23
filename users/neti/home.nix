{ config, pkgs, age, ... }:
# let
#   inherit (config.home.sessionVariables) XDG_RUNTIME_DIR;
# in
{
  config = {
    # home.sessionVariables.SSH_AUTH_SOCK = "${XDG_RUNTIME_DIR}/ssh-agent.sock";
    programs.git.userName = "Simon Pettersson";
    programs.git.userEmail = "simpet@netinsight.net";
    programs.ssh.extraConfig = "Include /run/secrets/neti/ssh.config";
    programs.teams.enable = true;
    programs.qtcreator.enable = true;
    services.ssh-agent.enable = true;
    services.ssh-agent.keys = [
      {
        key = "/run/secrets/neti/id_ed25519.neti";
        passphrase = "/run/secrets/neti/id_ed25519.pass";
      }
    ];
    systemd.user.startServices = true;
  };
}
