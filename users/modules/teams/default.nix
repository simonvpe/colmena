{ pkgs
, config
, lib
, ...
}:
let
  cfg = config.programs.teams;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.programs.teams.enable = mkEnableOption "teams";
  config = mkIf cfg.enable {
    home.packages = with pkgs; [ teams ];
  };
}
