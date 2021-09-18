{}:
{
  "module/battery" = {
    type = "internal/battery";
    full-at = "99";
    battery = "BAT0";
    adapter = "AC0";
    poll-interval = "5";
    format-charging = "<animation-charging> <label-charging>";
    format-discharging = "<animation-discharging> <label-discharging>";
    format-full = "<ramp-capacity> <label-full>";
    label-charging = "%percentage%%";
    label-discharging = "%percentage%%";
    label-full = " Fully charged";
    ramp-capacity-0 = "";
    ramp-capacity-1 = "";
    ramp-capacity-2 = "";
    ramp-capacity-3 = "";
    ramp-capacity-4 = "";
    bar-capacity-width = "10";
    animation-charging-0 = "";
    animation-charging-1 = "";
    animation-charging-2 = "";
    animation-charging-3 = "";
    animation-charging-4 = "";
    animation-charging-framerate = "750";
    animation-discharging-0 = "";
    animation-discharging-1 = "";
    animation-discharging-2 = "";
    animation-discharging-3 = "";
    animation-discharging-4 = "";
    animation-discharging-framerate = "500";
  };
}

