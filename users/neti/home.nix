{ pkgs, age, ... }:
{
  config.programs.git.userName = "Simon Pettersson";
  config.programs.git.userEmail = "simpet@netinsight.net";
  config.programs.ssh.extraConfig = "Include /run/secrets/neti/ssh.config";
  config.programs.teams.enable = true;
  config.programs.qtcreator.enable = true;
  config.services.ssh-agent.enable = true;
  config.services.ssh-agent.keyFiles = [ "/run/secrets/neti/id_ed25519.pass:/run/secrets/neti/id_ed25519.neti" ];
  config.systemd.user.startServices = true;
}
