#
# User configuration for neti.
#
# There are some files required to have vpn and ssh working as I don't
# want to check in any sensitive data into github.
#
# Notably you want to create the following files
# .ssh/config.neti
# .config/vpn
#
# Mind the hack that adds sudo NOPASSWD to run openfortivpn and resolvectl,
# that should be arranged by some other means.
#
{ config, pkgs, ... }:
{
  nix.trustedUsers = [ "neti" ];
  users.users.neti.isNormalUser = true;
  users.users.neti.extraGroups = [ "wheel" "docker" "libvirtd" "dialout" "video" ];
  home-manager.users.neti.imports = [ ../starlord/home ./vpn.nix ];
  home-manager.users.neti.home.packages = with pkgs; [ teams qtcreator ];
  home-manager.users.neti.programs.vscode.enable = true;
  home-manager.users.neti.programs.vscode.package = pkgs.vscode-fhs;
  home-manager.users.neti.programs.ssh.extraConfig = "Include ~/.ssh/config.neti";
  home-manager.users.neti.services.vpn.configFile = "~/.config/vpn";

  #
  # This is required for the vpn service to work since systemd-resolved
  # is a bit finnicky and openfortivpn needs root to run.
  #
  security.sudo.extraRules = [
    {
      users = [ "neti" ];
      commands = [
        {
          command = "${pkgs.systemd}/bin/resolvectl";
          options = [ "NOPASSWD" ];
        }
        {
          command = "${pkgs.openfortivpn}/bin/openfortivpn";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}

