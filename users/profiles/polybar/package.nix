{ i3, pkgs }:
let
  inherit i3;
  overrides.i3GapsSupport = true;
  overrides.alsaSupport = true;
  overrides.githubSupport = true;
  overrides.pulseSupport = true;
  attrs = pkg: {
    cmakeFlags = (pkg.cmakeFlags or [ ]) ++ [ "-DENABLE_I3=ON" ];
  };
in
(pkgs.polybar.override overrides).overrideAttrs attrs

