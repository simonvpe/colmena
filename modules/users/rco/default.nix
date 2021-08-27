{}: import ../starlord rec {
  username = "rco";
  extraConfig = { orig, pkgs }: {
    networking.extraHosts = ''
      10.4.6.96  gitlab.rco.local
      10.4.6.96  rbx.gitpages.rco.local
      10.4.6.16  rco-sto-utv01.rco.local
      10.4.7.241 rco-vault01.rco.local
      10.4.6.94  rco-st118.rco.local
      10.4.7.245 rco-gitcache-01.rco.local
      10.4.7.242 rco-gitrunner-01.rco.local
      10.4.7.243 rco-gitrunner-02.rco.local
      10.4.7.244 rco-gitrunner-03.rco.local
    '';
    services.resolved.fallbackDns = [ "10.4.6.10" ];
    services.resolved.domains = [ "rco.local" ];
    services.udev.extraRules = ''
      SUBSYSTEM=="usb", ATTRS{idVendor}=="1fc9", ATTRS{idProduct}=="012f", MODE="0666"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="1fc9", ATTRS{idProduct}=="0129", MODE="0666"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="1fc9", ATTRS{idProduct}=="0147", MODE="0666"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="15a2", ATTRS{idProduct}=="004f", MODE="0666"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="1fc9", ATTRS{idProduct}=="013e", MODE="0666"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="1fc9", ATTRS{idProduct}=="0146", MODE="0666"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="15a2", ATTRS{idProduct}=="0076", MODE="0666"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="15a2", ATTRS{idProduct}=="0054", MODE="0666"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="15a2", ATTRS{idProduct}=="0061", MODE="0666"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="15a2", ATTRS{idProduct}=="0063", MODE="0666"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="15a2", ATTRS{idProduct}=="0071", MODE="0666"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="15a2", ATTRS{idProduct}=="007d", MODE="0666"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="15a2", ATTRS{idProduct}=="0080", MODE="0666"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="1fc9", ATTRS{idProduct}=="0128", MODE="0666"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="1fc9", ATTRS{idProduct}=="0126", MODE="0666"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="1fc9", ATTRS{idProduct}=="0135", MODE="0666"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="1fc9", ATTRS{idProduct}=="0134", MODE="0666"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="1fc9", ATTRS{idProduct}=="012b", MODE="0666"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0525", ATTRS{idProduct}=="b4a4", MODE="0666"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0525", ATTRS{idProduct}=="b4a4", MODE="0666"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0525", ATTRS{idProduct}=="b4a4", MODE="0666"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="3016", ATTRS{idProduct}=="1001", MODE="0666"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="3016", ATTRS{idProduct}=="1001", MODE="0666"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="066f", ATTRS{idProduct}=="9afe", MODE="0666"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="066f", ATTRS{idProduct}=="9bff", MODE="0666"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0525", ATTRS{idProduct}=="a4a5", MODE="0666"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="18d1", ATTRS{idProduct}=="0d02", MODE="0666"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="3016", ATTRS{idProduct}=="0001", MODE="0666"
    '';
    home-manager.users.${username} = pkgs.lib.recursiveUpdate orig.home-manager.users.${username} {
      home.packages = orig.home-manager.users.${username}.home.packages ++ [
        (pkgs.callPackage ./vpn.nix { })
        pkgs.teams
      ];
      # home.file.".config/nix/nix.conf".source = ./nix.conf;
    };
   nix.binaryCaches = [
     "https://cache.nixos.org"
     # "http://rco-gitcache-01.rco.local:8099"
     # "http://rco-gitrunner-01.rco.local:5000"
     # "http://rco-gitrunner-02.rco.local:5000"
     # "http://rco-gitrunner-03.rco.local:5000"
   ];
   nix.trustedBinaryCaches = [
     "https://cache.nixos.org"
     # "http://rco-gitcache-01.rco.local:8099"
     # "http://rco-gitrunner-01.rco.local:5000"
     # "http://rco-gitrunner-02.rco.local:5000"
     # "http://rco-gitrunner-03.rco.local:5000"
   ];
   nix.requireSignedBinaryCaches = false;
    nix.trustedUsers = [ username ];
  };
}
