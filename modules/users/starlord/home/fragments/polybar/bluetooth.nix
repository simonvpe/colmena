{ fetchgit, bluez, blueberry }:

let
  src = fetchgit {
    url = "https://github.com/msaitz/polybar-bluetooth";
    rev = "44ae51f5d78e7e26810a59eaaf381f7bee887585";
    sha256 = "sha256-0BZvpBWEPoVsEEWsRCtSP7zFgtT70yNvRwlhjeFo+Gk=";
  };
in
{
  "module/bluetooth" = {
    type = "custom/script";
    exec = "PATH=${bluez}/bin:$PATH ${src}/bluetooth.sh";
    interval = 2;
    click-left = "exec ${blueberry}/bin/blueberry";
    click-right = "exec ${src}/toggle-bluetooth.sh";
    format-padding = "1";
    format-background = "#000000";
    format-foreground = "#ffffff";
  };
}

