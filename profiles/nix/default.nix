{ pkgs, inputs, ... }:
{
  nix = {
    autoOptimiseStore = true;
    gc.automatic = true;
    optimise.automatic = true;
    useSandbox = true;
    allowedUsers = [ "@wheel" ];
    trustedUsers = [ "root" "@wheel" ];
    extraOptions = ''
      min-free = 536870912
      keep-outputs = true
      keep-derivations = true
      fallback = true
      experimental-features = nix-command flakes
      sandbox-paths = /bin/sh=${pkgs.bash}/bin/sh
    '';
    nixPath = [
      "repl=${toString ./.}/repl.nix"
      "nixpkgs=${inputs.nixpkgs}"
    ];
    registry.nixpkgs.flake = inputs.nixpkgs;
    package = pkgs.nixUnstable;
  };

  nixpkgs = {
    config.allowUnfree = true;
  };
}
