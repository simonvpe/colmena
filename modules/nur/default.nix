{ config, lib, pkgs, ... }:
with lib;
let cfg = config.simux.nur;
in
{
  options.simux.nur = {
    enable = mkEnableOption "nur";
  };

  config = mkIf cfg.enable {
    nixpkgs.config.packageOverrides = pkgs: {
      nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
        inherit pkgs;
      };
    };
  };
}
