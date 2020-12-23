{ config, pkgs, ... }:

{
  nix = {
    trustedUsers = [ "starlord" ];
  };

  users = {
    users.starlord = {
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" "libvirtd" "dialout" ];
    };
  };
}
