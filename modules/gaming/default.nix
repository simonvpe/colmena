{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.simux.gaming;

in
{
  options.simux.gaming = {
    enable = mkEnableOption "gaming";
  };

  config = mkIf cfg.enable {
    programs.steam.enable = true;
    simux.x11.enable = true;
    nixpkgs.config.allowUnfree = true;
  };
}
