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
    font-0 = "Bitstream Vera Serif:pixelsize=20;3";
    font-1 = "Font Awesome 5 Free:style=regular:pixelsize=20;3";
    font-2 = "Font Awesome 5 Free:style=solid:pixelsize=20;3";
    font-3 = "Font Awesome 5 Brands:style=solid:pixelsize=20;3";
    font-4 = "Font Awesome 5 Brands:style=regular:pixelsize=20;3";
  };
}
