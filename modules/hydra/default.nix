{ config, lib, pkgs, ... }:
with lib;
let cfg = config.simux.hydra;
in
{
  options.simux.hydra = {
    enable = mkEnableOption "hydra";
  };

  config = mkIf cfg.enable {
    services.hydra.enable = true;
    services.hydra.hydraURL = "http://localhost:3000";
    services.hydra.notificationSender = "hydra@thesourcerer.se";
    services.hydra.buildMachinesFiles = [];
    services.hydra.useSubstitutes = true;
  };
}
