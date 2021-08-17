{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.simux.wifi;
in
{
  options.simux.wifi = {
    enable = mkEnableOption "wifi";
    device = mkOption {
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    networking.interfaces.${cfg.device}.useDHCP = true;
    networking.wireless.enable = true;
    networking.wireless.networks = {
      Cyberlink50.psk = "allyourbasearebelongstous";
      Strandhyddan.psk = "8972524000";
      RCO.psk = "logonrcowlan";
      Finkontoret.psk = "strosaitrosa";
      OWNIT-5GHz_BE20.psk = "Q72CRXMKP7BXYL"; # Elins
      SW.psk = "#saltyaf";
      OnePlus3.psk = "pappapappa";
      "513F8F".psk = "c9mior2jcy";
    };
  };
}
