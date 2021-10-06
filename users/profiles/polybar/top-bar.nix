{}:
{
  "bar/top" = {
    monitor = "\${env:MONITOR}";
    width = "100%";
    height = "1%";
    radius = 0;
    background = "\${colors.background}";
    foreground = "\${colors.foreground}";
    modules-left = "i3";
    modules-center = [
      "backlight-touch-down"
      "backlight-touch-up"
    ];
    modules-right = "bluetooth cpu pulseaudio wireless-network battery backlight date";
    module-margin = "5";
    font-0 = "DejaVu:pixelsize=20;3";
    font-1 = "Inconsolata Nerd Font:style=regular:pixelsize=20;3";
  };
}
