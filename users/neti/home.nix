{ pkgs, age, ... }:
{
  config.programs.git.userName = "Simon Pettersson";
  config.programs.git.userEmail = "simpet@netinsight.net";
  config.programs.ssh.extraConfig = "Include /run/secrets/neti/ssh.config";
  config.services.openforti-vpn.enable = true;
  config.services.openforti-vpn.configFile = "/run/secrets/neti/vpn.config";
  config.programs.teams.enable = true;
  config.programs.qtcreator.enable = true;
}
