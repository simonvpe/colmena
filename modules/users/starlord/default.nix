{ config, pkgs, ... }:
{
  nix.trustedUsers = [ "starlord" ];
  users.users.starlord.isNormalUser = true;
  users.users.starlord.extraGroups = [ "wheel" "docker" "libvirtd" "dialout" "video" ];
  home-manager.users.starlord = import ./home { inherit config pkgs; };
}
