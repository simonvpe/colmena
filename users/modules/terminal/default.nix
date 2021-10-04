#
# The terminal to use needs to be configured in various places,
# rather than spreading it around in different files we have one
# place to configure it, here.
#
{ config
, lib
, ...
}:
let
  cfg = config.terminal;
in
{
  options.terminal = {
    package = lib.mkOption {
      type = lib.types.package;
      description = "The package of the terminal to use";
    };

    path = lib.mkOption {
      type = lib.types.path;
      default = "${cfg.package}/bin/${cfg.package.pname}";
    };

    config = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = { };
    };
  };

  config = {
    xsession.windowManager.i3.config.terminal = cfg.path;
    programs.rofi.terminal = cfg.path;
    programs.${cfg.package.pname} = cfg.config // { enable = true; };
    home.sessionVariables.TERM = cfg.package.pname;
    xsession.initExtra = ''export TERM="${cfg.package.pname}"'';
    programs.bash.initExtra = ''export TERM="${cfg.package.pname}"'';
  };
}
