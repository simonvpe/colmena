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
    networking.wireless.enable = true;
    networking.wireless.networks = {
      Cyberlink50.psk = "allyourbasearebelongstous";
      Strandhyddan.psk = "8972524000";
      RCO.psk = "logonrcowlan";
      Finkontoret.psk = "strosaitrosa";
    };
  };
}
