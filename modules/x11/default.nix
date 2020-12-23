{ config, lib, pkgs, ... }:
with lib;
let cfg = config.simux.x11;
in
{
  options.simux.x11 = {
    enable = mkEnableOption "x11";
  };

  config = mkIf cfg.enable {
    services = {
      xserver = {
        enable = true;
        layout = "dvorak";
        xkbVariant = "pc102";
        xkbOptions = "caps:swapescape lv3:ralt_switch";

        displayManager = {
          lightdm.enable = true;
          defaultSession = "none+i3";
        };

        desktopManager = {
          xterm.enable = false;
        };

        windowManager = {
          i3.enable = true;
        };
      };
    };
    fonts = {
      fontDir.enable = true;
      enableGhostscriptFonts = true;
      fonts = with pkgs; [
        corefonts
        ttf_bitstream_vera
        emojione
        noto-fonts
        noto-fonts-emoji
        roboto
        font-awesome-ttf
      ];
      fontconfig = {
        defaultFonts = {
          serif = [ "Bitstream Vera Sans" "EmojiOne Color" "Font Awesome 5 Free" ];
          sansSerif = [ "Bitstream Vera Serif" "EmojiOne Color" "Font Awesome 5 Free" ];
          monospace = [ "Bitstream Vera Sans Mono" "EmojiOne Color" "Font Awesome 5 Free" ];
        };
      };
    };
  };
}
