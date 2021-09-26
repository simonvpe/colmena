{ self, hmUsers, lib, ... }:
{
  home-manager.users.starlord = hmUsers.starlord;

  nix.trustedUsers = [ "starlord" ];

  # age = {
  #   sshKeyPaths = [ "/home/starlord/.ssh/id_ed25519" ];
  #   secrets = {
  #     "starlord/ssh.config" = {
  #       file = "${self}/secrets/starlord/ssh.config.age";
  #       owner = "starlord";
  #       group = "users";
  #       mode = "0400";
  #     };
  #     "starlord/bw.password" = {
  #       file = "${self}/secrets/starlord/bw.password.age";
  #       owner = "starlord";
  #       group = "users";
  #       mode = "0400";
  #     };
  #   };
  # };

  users.users.starlord = {
    hashedPassword = "$6$WjQs8n.Ibo$y7lNx0OBkJi2O2gTO64BHbLfhsHIbXz3xOq0qbBuzUmVZRRVimyR7xJ0oQDGh0QgS0nWo/Iud4GTrUaFyHfOd/";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILpAEQtDJym2oytUzIzKV6/ZNvqKbF+kUIZn+J3CoBK3 starlord@hyperactivitydrive"
    ];
    isNormalUser = true;
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
