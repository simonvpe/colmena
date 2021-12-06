{ config
, pkgs
, lib
, ...
}:

{
  options.programs = {
    multitail.enable = lib.mkEnableOption "multitail";
  };

  config = {}
    // (lib.mkIf config.programs.multitail.enable {
      home.packages = [ pkgs.multitail ];
    });

}
