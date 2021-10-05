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
    ];
    fontconfig.defaultFonts = {
      serif = [ "Inconsolata Nerd Font" ];
      sansSerif = [ "Inconsolata Nerd Font" ];
      monospace = [ "Inconsolata Nerd Font Mono" ];
    };
  };
}
