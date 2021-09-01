{ xorg }:
{
  "module/backlight" = {
    type = "internal/backlight";
    card = "intel_backlight";
    use-actual-brightness = true;
    enable-scroll = true;
    format = "<label>";
    label = " %percentage%%";
  };
  "module/backlight-touch-down" = {
    type = "custom/text";
    content = "  ";
    content-foreground = "#fff";
    click-left = "${xorg.xbacklight}/bin/xbacklight -dec 10";
  };
  "module/backlight-touch-up" = {
    type = "custom/text";
    content = "    ";
    content-foreground = "#fff";
    click-left = "${xorg.xbacklight}/bin/xbacklight -inc 10";
  };
}
