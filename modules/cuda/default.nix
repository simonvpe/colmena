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
    hardware.opengl.enable = true;
    hardware.opengl.driSupport32Bit = true;
    hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
    hardware.opengl.setLdLibraryPath = true;
  };
}
