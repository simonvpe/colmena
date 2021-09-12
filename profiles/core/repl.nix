let
  flake = builtins.getFlake (toString ../../flake.nix);
  nixpkgs = import <nixpkgs> { };
in
{ inherit flake; }
// flake
// builtins
// nixpkgs
// nixpkgs.lib
  // flake.nixosConfigurations
