{ self, hmUsers, lib, ... }:
{
  home-manager.users.starlord = hmUsers.starlord;

  nix.trustedUsers = [ "starlord" ];

  users.users.starlord = {
    isNormalUser = true;
    hashedPassword = "$6$WjQs8n.Ibo$y7lNx0OBkJi2O2gTO64BHbLfhsHIbXz3xOq0qbBuzUmVZRRVimyR7xJ0oQDGh0QgS0nWo/Iud4GTrUaFyHfOd/";
    openssh.authorizedKeys.keyFiles = [
      ../public-keys/id_ed25519.starlord.pub
    ];
    extraGroups = [
      "wheel"
      "docker"
      "libvirtd"
      "dialout"
      "video"
    ];
    uid = 1000;
  };
}
