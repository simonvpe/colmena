{ config, pkgs, ... }:

''
# This file has been auto-generated by i3-config-wizard(1).
# It will not be overwritten, so edit it as you like.
#
# Should you change your keyboard layout some time, delete
# this file and re-run i3-config-wizard(1).
#

# i3 config file (v4)
#
# Please see https://i3wm.org/docs/userguide.html for a complete reference!

set $mod Mod4

# Font for window titles. Will also be used by the bar unless a different font
# is used in the bar {} block below.
font pango:monospace 12
#
# Detect where I am and adjust displays
exec --no-startup-id autorandr --change

# Set background and theme
#exec_always --no-startup-id ${pkgs.feh}/bin/feh --bg-scale ''${background}
#exec_always --no-startup-id ${pkgs.pywal}/bin/wal -n -b 000000 --saturate 1.0 -i ''${background}

# Configure the default keyboard
exec --no-startup-id ${pkgs.callPackage ../keyboard {}}

# Use pactl to adjust volume in PulseAudio.
bindsym XF86AudioRaiseVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +10%
bindsym XF86AudioLowerVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -10%
bindsym XF86AudioMute exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle

# Use Mouse+$mod to drag floating windows to their wanted position
floating_modifier $mod

# start a terminal
bindsym $mod+Return exec ${pkgs.termite}/bin/termite

# lock the screen
#exec --no-startup-id ~/.local/bin/lock server
#bindsym $mod+L exec --no-startup-id ~/.local/bin/lock now

# kill focused window
bindsym $mod+Shift+apostrophe kill

# start dmenu (a program launcher)
bindsym $mod+e exec --no-startup-id ${pkgs.rofi}/bin/rofi -show run
#
# # Swap capslock and ctrl
exec --no-startup-id setxkbmap -option "caps:swapescape"

# change focus
bindsym $mod+h focus left
bindsym $mod+t focus down
bindsym $mod+n focus up
bindsym $mod+s focus right

# alternatively, you can use the cursor keys:
bindsym $mod+Left focus left
bindsym $mod+Down focus down
bindsym $mod+Up focus up
bindsym $mod+Right focus right

# move focused window
bindsym $mod+Shift+h move left
bindsym $mod+Shift+t move down
bindsym $mod+Shift+n move up
bindsym $mod+Shift+s move right

# alternatively, you can use the cursor keys:
bindsym $mod+Shift+Left move left
bindsym $mod+Shift+Down move down
bindsym $mod+Shift+Up move up
bindsym $mod+Shift+Right move right

# split in horizontal orientation
bindsym $mod+d split h

# split in vertical orientation
bindsym $mod+k split v

# enter fullscreen mode for the focused container
bindsym $mod+u fullscreen toggle

# change container layout (stacked, tabbed, toggle split)
bindsym $mod+o layout stacking
bindsym $mod+comma layout tabbed
bindsym $mod+period layout toggle split

# toggle tiling / floating
bindsym $mod+Shift+space floating toggle

# cycle keyboard
bindsym $mod+space exec --no-startup-id ${pkgs.callPackage ../keyboard {}}

# focus the parent container
bindsym $mod+a focus parent

# focus the child container
#bindsym $mod+d focus child

# Define names for default workspaces for which we configure key bindings later on.
# We use variables to avoid repeating the names in multiple places.
set $ws1 "1"
set $ws2 "2"
set $ws3 "3"
set $ws4 "4"
set $ws5 "5"
set $ws6 "6"
set $ws7 "7"
set $ws8 "8"
set $ws9 "9"
set $ws10 "10"

# switch to workspace
bindsym $mod+1 workspace $ws1
bindsym $mod+2 workspace $ws2
bindsym $mod+3 workspace $ws3
bindsym $mod+4 workspace $ws4
bindsym $mod+5 workspace $ws5
bindsym $mod+6 workspace $ws6
bindsym $mod+7 workspace $ws7
bindsym $mod+8 workspace $ws8
bindsym $mod+9 workspace $ws9
bindsym $mod+0 workspace $ws10

# move focused container to workspace
bindsym $mod+Shift+1 move container to workspace $ws1
bindsym $mod+Shift+2 move container to workspace $ws2
bindsym $mod+Shift+3 move container to workspace $ws3
bindsym $mod+Shift+4 move container to workspace $ws4
bindsym $mod+Shift+5 move container to workspace $ws5
bindsym $mod+Shift+6 move container to workspace $ws6
bindsym $mod+Shift+7 move container to workspace $ws7
bindsym $mod+Shift+8 move container to workspace $ws8
bindsym $mod+Shift+9 move container to workspace $ws9
bindsym $mod+Shift+0 move container to workspace $ws10

# reload the configuration file
bindsym $mod+Shift+j reload
# restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
bindsym $mod+Shift+p restart
# exit i3 (logs you out of your X session)
bindsym $mod+Shift+period exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -B 'Yes, exit i3' 'i3-msg exit'"

# resize window (you can also use the mouse for that)
mode "resize" {
        # These bindings trigger as soon as you enter the resize mode

        # Pressing left will shrink the window’s width.
        # Pressing right will grow the window’s width.
        # Pressing up will shrink the window’s height.
        # Pressing down will grow the window’s height.
        bindsym h resize shrink width 10 px or 10 ppt
        bindsym t resize grow height 10 px or 10 ppt
        bindsym n resize shrink height 10 px or 10 ppt
        bindsym s resize grow width 10 px or 10 ppt

        # same bindings, but for the arrow keys
        bindsym Left resize shrink width 10 px or 10 ppt
        bindsym Down resize grow height 10 px or 10 ppt
        bindsym Up resize shrink height 10 px or 10 ppt
        bindsym Right resize grow width 10 px or 10 ppt

        # back to normal: Enter or Escape or $mod+r
        bindsym Return mode "default"
        bindsym Escape mode "default"
        bindsym $mod+p mode "default"
}

bindsym $mod+p mode "resize"

# Start i3bar to display a workspace bar (plus the system information i3status
# finds out, if available)
# bar {
#         position top
#         status_command i3blocks

# }

for_window [class=".*"] border pixel 0
gaps inner 20
gaps outer 5
smart_gaps on
smart_gaps inverse_outer
smart_borders on
smart_borders no_gaps

# Set colors from Xresources
# Change 'color7' and 'color2' to whatever colors you want i3 to use
# from the generated scheme.
# NOTE: The '#f0f0f0' in the lines below is the color i3 will use if
# it fails to get colors from Xresources for some reason.
set_from_resource $fg i3wm.color7 #f0f0f0
set_from_resource $bg i3wm.color2 #f0f0f0

# class                 border  backgr. text indicator child_border
client.focused          $bg     $bg     $fg  $bg       $bg
client.focused_inactive $bg     $bg     $fg  $bg       $bg
client.unfocused        $bg     $bg     $fg  $bg       $bg
client.urgent           $bg     $bg     $fg  $bg       $bg
client.placeholder      $bg     $bg     $fg  $bg       $bg

client.background       $bg
''
