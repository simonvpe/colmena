{ config, pkgs, ... }:
let
  wifi = if !config.simux.wifi.enable then "" else ''
    # simux.wifi.enable
    [wifi]
    command=${../../../../wifi/wifi-statusbar} ${config.simux.wifi.device}
    interval=5
  '';

  battery = ''
    [battery]
    command=${pkgs.writeTextFile {
      name = "battery-statusbar";
      executable = true;
      text = ''
        #!/usr/bin/env bash
        readonly capacity=$(cat /sys/class/power_supply/BAT0/capacity) || exit
        readonly status=$(cat /sys/class/power_supply/BAT0/status)

        if [ "$capacity" -ge 75 ]; then
          color="$(xrdb -query | grep '*color5' | awk '{print $NF}')"
        elif [ "$capacity" -ge 50 ]; then
          color="$(xrdb -query | grep '*color4' | awk '{print $NF}')"
        elif [ "$capacity" -ge 25 ]; then
          color="$(xrdb -query | grep '*color3' | awk '{print $NF}')"
        else
          color="$(xrdb -query | grep '*color3' | awk '{print $NF}')"
        fi

        if [ "$status" = Charging ]; then
          color="$(xrdb -query | grep '*color5' | awk '{print $NF}')"
        fi

        sym=$(echo "$status" | sed -e "s/,//;s/Discharging/🔋/;s/Not Charging/🛑/;s/Charging/🔌/;s/Unknown/♻️/;s/Full/⚡/;s/ 0*/ /g;s/ :/ /g")
        cap=$(echo "$capacity" | sed -e 's/$/%/')
        printf '<span color="%s">%s%s</span>\n' "$color" "$sym" "$cap"
      '';
    }}
    interval=5
  '';

  date = ''
    [date]
    command=${pkgs.writeTextFile {
      name = "date-statusbar";
      executable = true;
      text = ''
        #!/usr/bin/env bash
        readonly color="$(xrdb -query | grep '*color5'| awk '{print $NF}')"
        readonly date="$(date)"
        printf '<span color="%s">%s</span>\n' "$color" "$date"
      '';
    }}
    interval=1
  '';
in
''
# https://github.com/LukeSmithxyz/voidrice
separator_block_width=15
markup=pango

${wifi}

${battery}

${date}
''
