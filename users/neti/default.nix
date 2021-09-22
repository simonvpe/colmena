{ self, hmUsers, pkgs, ... }:
{
  home-manager.users.neti = hmUsers.neti;

  nix.trustedUsers = [ "neti" ];

  users.users.neti = {
    hashedPassword = "$6$WjQs8n.Ibo$y7lNx0OBkJi2O2gTO64BHbLfhsHIbXz3xOq0qbBuzUmVZRRVimyR7xJ0oQDGh0QgS0nWo/Iud4GTrUaFyHfOd/";
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "libvirtd" "dialout" "video" ];
  };

  age = {
    sshKeyPaths = [ "/home/neti/.ssh/id_ed25519" ];
    secrets = {
      "neti/id_ed25519.neti.pub" = {
        file = "${self}/secrets/neti/id_ed25519.neti.pub.age";
        owner = "neti";
        group = "users";
        mode = "0440";
      };
      "neti/id_ed25519.neti" = {
        file = "${self}/secrets/neti/id_ed25519.neti.age";
        owner = "neti";
        group = "users";
        mode = "0400";
      };
      "neti/vpn.config" = {
        file = "${self}/secrets/neti/vpn.config.age";
        owner = "neti";
        group = "users";
        mode = "0400";
      };
      "neti/ssh.config" = {
        file = "${self}/secrets/neti/ssh.config.age";
        owner = "neti";
        group = "users";
        mode = "0400";
      };
      "neti/id_ed25519.pass" = {
        file = "${self}/secrets/neti/id_ed25519.pass.age";
        owner = "neti";
        group = "users";
        mode = "0400";
      };
    };
  };

  services.openfortivpn = [{
    enable = true;
    configPath = "/run/secrets/neti/vpn.config";
    users = [ "neti" ];
  }];
}
