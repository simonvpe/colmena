{ config, pkgs, ... }:
let
  wifi = ''
    [wifi]
    command=${pkgs.writeTextFile {
      name = "wifi-statusbar";
      executable = true;
      text = ''
          #!/usr/bin/env bash
          readonly nic=wlp59s0
          readonly signal=$(grep $nic /proc/net/wireless | awk '{ print int($3 * 100 / 70) }')
          readonly ssid=$(iwgetid | grep $nic | cut -d: -f2 | sed 's/"//g')
          readonly white="$(xrdb -query | grep '*color5' | awk '{print $NF}')"
          readonly orange="$(xrdb -query | grep '*color4' | awk '{print $NF}')"
          readonly orangered="$(xrdb -query | grep '*color3' | awk '{print $NF}')"
          readonly symbol=

          [[ ! -d /sys/class/net/$nic/wireless ]] && exit

          # If the wifi interface exists but no connection is active, "down" shall be displayed.
          case "$(cat /sys/class/net/$nic/operstate)" in
              up)
              if [[ $signal -ge 75 ]]; then
                  printf '<span color="%s">%s %s</span>\n' "$white" "$symbol" "$ssid"
              elif [[ $signal -ge 50 ]]; then
                  printf '<span color="%s">%s %s</span>\n' "$orange" "$symbol" "$ssid"
              else
                  printf '<span color="%s">%s %s</span>\n' "$orangered" "$symbol" "$ssid"
              fi
              ;;

              down)
              printf '<span color="%s">%s</span>\n' "#333333" "$symbol"
              ;;
          esac
      '';
    }}
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
          color="$(xrdb -query | grep '*color2' | awk '{print $NF}')"
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
