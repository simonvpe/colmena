{ config, pkgs, ... }:
{
  nix.trustedUsers = [ "neti" ];
  users.users.neti.isNormalUser = true;
  users.users.neti.extraGroups = [ "wheel" "docker" "libvirtd" "dialout" "video" ];

  home-manager.users.neti.imports = [ ../starlord/home ./vpn.nix ];

  home-manager.users.neti.home.packages = with pkgs; [ teams qtcreator ];

  home-manager.users.neti.programs.vscode.enable = true;
  home-manager.users.neti.programs.vscode.package = pkgs.vscode-fhs;

  home-manager.users.neti.services.vpn.configFile = "~/.config/vpn";

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

  home-manager.users.neti.programs.ssh.extraConfig = ''
    Host delia
        HostName 10.100.1.164
        User simpet
        IdentityFile ~/.ssh/id_ed25519.neti
  '';
}

