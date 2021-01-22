{ config, lib, pkgs, ... }:
with lib;
let cfg = config.simux.flakes;
in
{
  options.simux.flakes = {
    enable = mkEnableOption "flakes";
  };

  config = mkIf cfg.enable {
    nix = {
      package = pkgs.nixFlakes;
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
    };
  };
}
