{ config, pkgs, ... }:
let
  wifi = if !config.simux.wifi.enable then "" else ''
    # simux.wifi.enable
    [wifi]
    command=${../../../../wifi/wifi-statusbar} ${config.simux.wifi.device}
    interval=5
  '';

  battery = if !config.simux.battery.enable then "" else ''
    # simux.battery.enable
    [battery]
    command=${../../../../battery/battery-statusbar} ${config.simux.battery.device}
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
