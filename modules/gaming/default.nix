{ config, lib, pkgs, ... }:
with lib;
let cfg = config.simux.gaming;
in
{
  options.simux.gaming = {
    enable = mkEnableOption "gaming";
  };

  config = mkIf cfg.enable {
    simux.x11.enable = true;
    environment.systemPackages = [ pkgs.steam ];
    nixpkgs.config.allowUnfree = true;
  };
}
