{ self, hmUsers, pkgs, ... }:
{
  home-manager.users.neti = hmUsers.neti;

  nix.trustedUsers = [ "neti" ];

  users.users.neti = {
    hashedPassword = "$6$WjQs8n.Ibo$y7lNx0OBkJi2O2gTO64BHbLfhsHIbXz3xOq0qbBuzUmVZRRVimyR7xJ0oQDGh0QgS0nWo/Iud4GTrUaFyHfOd/";
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "libvirtd" "dialout" "video" ];
    uid = 1002;
  };

  services.openfortivpn = [{
    enable = true;
    configPath = "/home/neti/.config/vpn.config";
    users = [ "neti" ];
  }];
}
