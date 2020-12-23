{ config, pkgs, ... }:
{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "battery-statusbar" (builtins.readFile ./battery-statusbar))
  ];
}
