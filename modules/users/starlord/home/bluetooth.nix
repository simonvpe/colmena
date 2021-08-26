{ fetchgit, bluez, writeScriptBin, symlinkJoin }:

let
  src = fetchgit {
    url = "https://github.com/msaitz/polybar-bluetooth";
    rev = "44ae51f5d78e7e26810a59eaaf381f7bee887585";
    sha256 = "sha256-0BZvpBWEPoVsEEWsRCtSP7zFgtT70yNvRwlhjeFo+Gk=";
  };

  script = "${src}/bluetooth.sh";

  bluetooth = writeScriptBin "polybar-bluetooth.sh" ''
    export PATH=${bluez}/bin:$PATH
    exec ${src}/bluetooth.sh
  '';

  toggleBluetooth = writeScriptBin "toggle-bluetooth.sh" ''
    export PATH=${bluez}/bin:$PATH
    exec ${src}/toggle_bluetooth.sh
  '';
in
symlinkJoin { name = "polybar-bluetooth"; paths = [ bluetooth toggleBluetooth ]; }

