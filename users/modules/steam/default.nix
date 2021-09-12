{ config
, pkgs
, lib
, ...
}:

let
  cfg = config.programs.steam;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.programs.steam.enable = mkEnableOption "steam";

  config = mkIf cfg.enable {
    home.packages = [ pkgs.steam ];
  };
}
