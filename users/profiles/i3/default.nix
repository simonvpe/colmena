{ config
, pkgs
, ...
}:

let background = pkgs.callPackage ./background.nix { };
in
{
  config.xsession = {
    enable = true;
    windowManager = {
      i3.enable = true;
      i3.package = pkgs.i3-gaps;
      i3.config = rec {
        modifier = "Mod4";
        bars = [ ];
        fonts.names = [ "pango:monospace" ];
        fonts.size = 11.0;
        floating.modifier = modifier;
        startup = [
          { command = "${pkgs.autorandr}/bin/autorandr"; always = false; }
          { command = "${pkgs.feh}/bin/feh --bg-scale ${background}"; always = true; }
          { command = "${pkgs.pywal}/bin/wal -n -b 000000 --saturate 1.0 -i ${background}"; always = true; }
          { command = "${pkgs.xorg.xinput}/bin/xinput --set-prop 'ASUE140A:00 04F3:3134 Touchpad' 'libinput Disable While Typing Enabled' 1"; always = true; }
          { command = "${./monitor-sensor.sh} eDP-1 'ELAN9008:00 04F3:2BB3 Stylus Pen (0)' 'ELAN9008:00 04F3:2BB3'"; always = true; }
          { command = "setxkbmap -option caps:swapescape"; always = false; }
        ];
        keybindings = {
          # Audio
          "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +10%";
          "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -10%";
          "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle";

          # Backlight
          "XF86MonBrightnessUp" = "exec --no-startup-id ${pkgs.light}/bin/light -A 10";
          "XF86MonBrightnessDown" = "exec --no-startup-id ${pkgs.light}/bin/light -U 10";

          # Start apps
          "${modifier}+Return" = "exec ${config.xsession.windowManager.i3.config.terminal}";
          "${modifier}+e" = "exec --no-startup-id ${pkgs.rofi}/bin/rofi -show run";

          # Window management
          "${modifier}+Shift+apostrophe" = "kill";
          "${modifier}+h" = "focus left";
          "${modifier}+t" = "focus down";
          "${modifier}+n" = "focus up";
          "${modifier}+s" = "focus right";
          "${modifier}+Shift+h" = "move left";
          "${modifier}+Shift+t" = "move down";
          "${modifier}+Shift+n" = "move up";
          "${modifier}+Shift+s" = "move right";
          "${modifier}+d" = "split h";
          "${modifier}+k" = "split v";
          "${modifier}+u" = "fullscreen toggle";
          "${modifier}+o" = "layout stacking";
          "${modifier}+comma" = "layout tabbed";
          "${modifier}+period" = "layout toggle split";
          "${modifier}+Shift+space" = "floating toggle";
          "${modifier}+a" = "focus parent";
          "${modifier}+p" = "mode resize";

          # Workspace management
          "${modifier}+1" = "workspace 1";
          "${modifier}+2" = "workspace 2";
          "${modifier}+3" = "workspace 3";
          "${modifier}+4" = "workspace 4";
          "${modifier}+5" = "workspace 5";
          "${modifier}+6" = "workspace 6";
          "${modifier}+7" = "workspace 7";
          "${modifier}+8" = "workspace 8";
          "${modifier}+9" = "workspace 9";
          "${modifier}+Shift+1" = "move container to workspace 1";
          "${modifier}+Shift+2" = "move container to workspace 2";
          "${modifier}+Shift+3" = "move container to workspace 3";
          "${modifier}+Shift+4" = "move container to workspace 4";
          "${modifier}+Shift+5" = "move container to workspace 5";
          "${modifier}+Shift+6" = "move container to workspace 6";
          "${modifier}+Shift+7" = "move container to workspace 7";
          "${modifier}+Shift+8" = "move container to workspace 8";
          "${modifier}+Shift+9" = "move container to workspace 9";
        };
        modes.resize = {
          "h" = "resize shrink width 10 px or 10 ppt";
          "t" = "resize grow height 10 px or 10 ppt";
          "n" = "resize shrink height 10 px or 10 ppt";
          "s" = "resize grow width 10 px or 10 ppt";
          "Escape" = "mode default";
        };
        gaps = {
          inner = 20;
          outer = 5;
          smartGaps = true;
          smartBorders = "no_gaps";
        };
      };
      i3.extraConfig = ''
        floating_minimum_size 75 x 50
        floating_maximum_size 1920 x 1080
      '';
    };
  };
}
