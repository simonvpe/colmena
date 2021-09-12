{ ... }:
{
  config.systemd.services.battery-charge-threshold = {
    wantedBy = [ "multi-user.target" ];
    after = [ "multi-user.target" ];
    description = "Set the battery charge threshold";
    startLimitBurst = 60;
    serviceConfig = {
      Type = "oneshot";
      Restart = "on-failure";
      ExecStart = "/bin/sh -c 'echo 80 > /sys/class/power_supply/BAT0/charge_control_end_threshold'";
    };
  };
}
