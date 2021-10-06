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
      inconsolata
      inconsolata-nerdfont
      dejavu_fonts
    ];
    fontconfig.defaultFonts = {
      serif = [ "DejaVu Sans" "Inconsolata Nerd Font" ];
      sansSerif = [ "DejaVu Sans" "Inconsolata Nerd Font" ];
      monospace = [ "Inconsolata Nerd Font Mono" ];
    };
  };
}
