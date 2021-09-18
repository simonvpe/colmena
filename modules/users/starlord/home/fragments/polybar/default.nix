{ config
, pkgs
, lib
, ...
}:

{
  config.services.polybar = rec {
    enable = true;

    package =
      let
        inherit (pkgs) i3;
        overrides.i3GapsSupport = true;
        overrides.alsaSupport = true;
        overrides.githubSupport = true;
        overrides.pulseSupport = true;
        attrs = pkg: {
          cmakeFlags = (pkg.cmakeFlags or []) ++ [ "-DENABLE_I3=ON" ];
        };
      in
      (pkgs.polybar.override overrides).overrideAttrs attrs;

    script =
      let
        inherit (pkgs) gnugrep coreutils xorg;
        inherit (xorg) xrandr;
      in
      ''
        export PATH=${xrandr}/bin:${gnugrep}/bin:${coreutils}/bin:$PATH
        for monitor in $(xrandr --query | grep " connected" | cut -d' ' -f1); do
          MONITOR=$monitor ${package}/bin/polybar top &
        done
      '';

    config =
      (import ./backlight.nix { inherit (pkgs) light; }) //
      (import ./battery.nix {}) //
      (import ./bluetooth.nix { inherit (pkgs) fetchgit bluez blueberry; }) //
      (import ./colors.nix {}) //
      (import ./cpu.nix {}) //
      (import ./date.nix {}) //
      (import ./i3.nix {}) //
      (import ./pulseaudio.nix {}) //
      (import ./top-bar.nix {}) //
      (import ./wireless-network.nix {});
  };
}

