{}:
{
  "module/pulseaudio" = {
    type = "internal/pulseaudio";
    # TODO: sink = "@DEFAULT_SINK@"?
    sink = "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi___ucm0001.hw_sofhdadsp__sink";
    use-ui-max = true;
    interval = 5;
    format-volume = "<label-volume>";
    format-muted = "<label-muted>";
    label-volume = " %percentage%%";
    label-muted = " 0%";
  };
  "module/pulseaudio-touch-mute" = {
    type = "custom/text";
    content = "  ";
    content-foreground = "#fff";
    click-left = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
  };
  "module/pulseaudio-touch-down" = {
    type = "custom/text";
    content = "  ";
    content-foreground = "#fff";
    click-left = "pactl set-sink-volume @DEFAULT_SINK@ -5%";
  };
  "module/pulseaudio-touch-up" = {
    type = "custom/text";
    content = "    ";
    content-foreground = "#fff";
    click-left = "pactl set-sink-volume @DEFAULT_SINK@ +5%";
  };
}
