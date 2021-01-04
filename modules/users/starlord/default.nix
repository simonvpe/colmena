{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.simux.starlord;
  external = import ../../../external;

in
{
  options.simux.starlord = {
    enable = mkEnableOption "starlord user";
    enableHomeManager = mkOption {
      type = types.bool;
      default = false;
    };
  };

  imports = [
    (import "${external.home-manager}/nixos")
  ];

  config = mkMerge [
    (mkIf cfg.enable {
      nix.trustedUsers = [ "starlord" ];
      users.users.starlord.isNormalUser = true;
      users.users.starlord.extraGroups = [ "wheel" "docker" "libvirtd" "dialout" ];
      simux.nur.enable = true;})
    (mkIf (cfg.enable && cfg.enableHomeManager) {
      home-manager.users.starlord = import ./home { inherit pkgs config; };
    })
  ];
}
