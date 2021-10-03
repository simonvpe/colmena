{ host }:
let
  flake = builtins.getFlake (toString ../../.);
  nixpkgs = import <nixpkgs> { };
in
{ inherit flake; }
// flake
// builtins
// nixpkgs
// nixpkgs.lib
  // {
  simux.config = flake.nixosConfigurations.${host};
  simux.channels = flake.pkgs.${builtins.currentSystem};
  getFlake = path: builtins.getFlake (builtins.toString path);
}
