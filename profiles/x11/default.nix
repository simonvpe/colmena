{ pkgs, ... }:
{

  services.xserver = {
    enable = true;
    layout = "dvorak";
    xkbVariant = "pc102";
    xkbOptions = "caps:swapescape lv3:ralt_switch";
    displayManager.lightdm.enable = true;
    displayManager.defaultSession = "none+i3";
    desktopManager.xterm.enable = true;
    windowManager.i3.enable = true;
  };

  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts
      emojione
      font-awesome
      font-awesome-ttf
      noto-fonts
      noto-fonts-emoji
      roboto
      siji
      ttf_bitstream_vera
    ];
    fontconfig.defaultFonts = {
      serif = [ "Bitstream Vera Sans" "EmojiOne Color" "Font Awesome 5 Free" ];
      sansSerif = [ "Bitstream Vera Serif" "EmojiOne Color" "Font Awesome 5 Free" ];
      monospace = [ "Bitstream Vera Sans Mono" "EmojiOne Color" "Font Awesome 5 Free" ];
    };
  };
}
