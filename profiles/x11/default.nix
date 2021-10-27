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
      # Microsoft's TrueType core fonts for the Web
      corefonts
      # Iconic font aggregator, collection, & patcher. 3,600+ icons, 50+ patched fonts
      nerdfonts
      # Meslo Nerd Font patched for Powerlevel10k
      meslo-lgs-nf
    ];
    fontconfig.defaultFonts = {
      serif = [ "NotoSerif Nerd Font" ];
      sansSerif = [ "NotoSerif Nerd Font" ];
      monospace = [ "MesloLGS Nerd Font Mono" ];
    };
  };
}
