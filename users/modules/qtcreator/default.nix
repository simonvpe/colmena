{ pkgs
, config
, lib
, ...
}:
let
  cfg = config.programs.qtcreator;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.programs.qtcreator.enable = mkEnableOption "qtcreator";
  config = mkIf cfg.enable {
    home.packages = with pkgs; [ qtcreator ];
  };
}
