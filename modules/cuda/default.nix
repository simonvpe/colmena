{ config, lib, pkgs, ... }:
with lib;
let cfg = config.simux.cuda;
in
{
  options.simux.cuda = {
    enable = mkEnableOption "cuda";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.cudatoolkit ];
    nixpkgs.config.allowUnfree = true;
  };
}
