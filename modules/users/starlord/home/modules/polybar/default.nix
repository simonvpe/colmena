{ config
, pkgs
, lib
, ...
}:

let
  inherit (pkgs) i3 callPackage gnugrep coreutils xorg;
in
{
  options = {};

  config.services.polybar = rec {
    enable = true;
    package = callPackage ./package.nix { inherit i3; };
    script = ''
      export PATH=${xorg.xrandr}/bin:${gnugrep}/bin:${coreutils}/bin:$PATH
      for monitor in $(xrandr --query | grep " connected" | cut -d' ' -f1); do
        MONITOR=$monitor ${package}/bin/polybar top &
      done
    '';

    config =
    (import ./backlight.nix { inherit (pkgs) xorg; }) //
    (import ./battery.nix {}) //
    (import ./bluetooth.nix { inherit (pkgs) fetchgit bluez blueberry; }) //
    (import ./colors.nix {}) //
    (import ./cpu.nix {}) //
    (import ./i3.nix {}) //
    (import ./pulseaudio.nix {}) //
    (import ./top-bar.nix {}) //
    (import ./wireless-network.nix {})
    ;

      # lib.foldr (lhs: rhs: lhs // rhs) {} (map (x: callPackage x {}) [
      # ./backlight.nix
      # ./battery.nix
      # ./bluetooth.nix
      # ./colors.nix
      # ./cpu.nix
      # ./i3.nix
      # ./pulseaudio.nix
      # ./top-bar.nix
      # ./wireless-network.nix
    # ]);
  };
}

