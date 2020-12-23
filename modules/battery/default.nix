{ config, lib, pkgs, ... }:
with lib;
let cfg = config.simux.battery;
in
{
  options.simux.battery = {
    enable = mkEnableOption "battery utils";
    device = mkOption {
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      (pkgs.writeShellScriptBin "battery-statusbar" (builtins.readFile ./battery-statusbar))
    ];
  };
}
