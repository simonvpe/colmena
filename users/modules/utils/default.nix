{ config
, pkgs
, lib
, ...
}:

{
  options.programs.multitail.enableMultitail = mkEnableOption "multitail";

  config = {}
    // (mkIf cfg.enableMultitail {
      home.packages = [ pkgs.multitail ];
    });

}
