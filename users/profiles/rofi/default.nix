{ pkgs, ... }:
{
  config.programs.rofi = {
    enable = true;
    theme = "~/.cache/wal/colors-rofi-dark.rasi";
  };
}
