{ config, pkgs, ... }:

{
  networking.wireless.enable = true;
  networking.wireless.networks = {
    Cyberlink50.psk = "allyourbasearebelongstous";
    Strandhyddan.psk = "8972524000";
    RCO.psk = "logonrcowlan";
  };
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "wifi-statusbar" (builtins.readFile ./wifi-statusbar))
  ];
}
