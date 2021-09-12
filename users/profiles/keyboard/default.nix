{ config
, pkgs
, lib
, ...
}:

let
  cfg = config.keyboard;
  i3 = config.xsession.windowManager.i3.config;
  mod = i3.modifier;

  inherit (lib) mkIf mkMerge;
  inherit (pkgs) writeScriptBin;
  inherit (pkgs.xorg) setxkbmap xkbcomp;

  script = writeScriptBin "cycle-keyboard" ''
    #!/usr/bin/env bash
    set -o pipefail -o nounset -o errexit

    readonly state="/run/user/$(id -u)/keyboard"

    if [[ -n "''${1:-}" ]] ;then
        ${setxkbmap}/bin/setxkbmap $1 -print | ${xkbcomp}/bin/xkbcomp -I$HOME/.xkb -w 0 - $DISPLAY
        printf '%s\n' $1 > ''${state}
    else
        if [[ -f "''${state}" ]]; then
            case "$(< ''${state})" in
                evorak) "$0" svorak ;;
                svorak) "$0" evorak ;;
            esac
        else
            "$0" evorak
        fi
    fi
  '';

in
{
  config.home.packages = [ script ];
  config.home.file.".xkb/symbols/svorak".source = ./svorak;
  config.home.file.".xkb/symbols/evorak".source = ./evorak;
  config.xsession.windowManager.i3.config.startup = [
    { command = "${script}/bin/${script.meta.name}"; }
  ];
  config.xsession.windowManager.i3.config.keybindings = {
    "${mod}+space" = "exec --no-startup-id ${script}/bin/${script.meta.name}";
  };
}

