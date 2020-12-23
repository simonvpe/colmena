let
   home-manager = builtins.fetchGit {
    url = "https://github.com/rycee/home-manager.git";
    rev = "63f299b3347aea183fc5088e4d6c4a193b334a41";
    ref = "release-20.09";
  };
  nixos-hardware = builtins.fetchGit {
    url = "https://github.com/NixOS/nixos-hardware.git";
    rev = "87522b29a276a4cab5718e5309aa7d74bc7de75a";
    ref = "master";
  };
in
{
  meta = {
    # Override to pin the Nixpkgs version (recommended). This option
    # accepts one of the following:
    # - A path to a Nixpkgs checkout
    # - The Nixpkgs lambda (e.g., import <nixpkgs>)
    # - An initialized Nixpkgs attribute set
    nixpkgs = <nixpkgs>;

    # You can also override Nixpkgs by node!
    # nodeNixpkgs = {
    #   node-b = ./another-nixos-checkout;
    # };
  };

  defaults = { pkgs, ... }: {
    imports = [
      (import "${home-manager}/nixos")
    ];

    environment = {
      systemPackages = with pkgs; [
        curl
        git
        nodePackages.bitwarden-cli
        ntfs3g
        vim
        wget
      ];
      variables.XCURSOR_SIZE = "64";
      pathsToLink = [ "/libexec" ];
    };

    time = {
      timeZone = "Europe/Stockholm";
    };

    nix = {
      trustedBinaryCaches = [
        "http://agentx.rco.local:8099/"
      ];
      binaryCachePublicKeys = [
        "agentx.rco.local:bZokcSvOeSOpSaZ7/SYCvTJj/563rERm0oFMUvfmK1o="
      ];
      requireSignedBinaryCaches = true;
      maxJobs = pkgs.lib.mkDefault 12;
      trustedUsers = [ "starlord" ];
    };

    nixpkgs = {
      config.allowUnfree = true;
    };

    sound = {
      enable = true;
    };

    hardware = {
      pulseaudio.enable = true;
      opengl.driSupport32Bit = true;
    };

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

      resolved = {
        enable = true;
        #fallbackDns = [ "10.4.6.10" ];
        fallbackDns = [ "1.1.1.1" "8.8.8.8" ];
        domains = [ "rco.local" ];
      };

      nscd = {
        enable = true;
      };

      openssh = {
        enable = true;
      };

      udev.extraRules = ''
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

    console = {
      font = "Lat2-Terminus16";
      keyMap = "dvorak";
    };

    i18n = {
      defaultLocale = "en_US.UTF-8";
    };

    virtualisation = {
      docker = {
        enable = true;
        enableNvidia = true;
        enableOnBoot = true;
      };
      libvirtd.enable = true;
    };

    users = {
      users.starlord = {
        isNormalUser = true;
        extraGroups = [ "wheel" "docker" "libvirtd" "dialout" ];
      };
    };

  };

  laptop = { name, nodes, pkgs, ... }:
  let machine = ./home + "/${name}";
  in
  {
    imports = [
      <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
      (nixos-hardware + "/dell/xps/15-9500/nvidia")
    ];

    boot = {
      extraModulePackages = [ ];
      initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
      initrd.kernelModules = [ ];
      kernelModules = [ "kvm-intel" ];
      loader.grub.configurationLimit = 2;
      loader.grub.device = "nodev";
      loader.grub.efiInstallAsRemovable = true;
      loader.grub.efiSupport = true;
      loader.grub.enable = true;
      loader.grub.useOSProber = true;
      loader.grub.version = 2;
      supportedFilesystems = [ "ntfs" ];
    };

    deployment = {
      allowLocalDeployment = true;
    };

    fileSystems = {
      "/".device = "/dev/disk/by-uuid/4c8e4486-331f-4963-9fa9-6800109beca9";
      "/".fsType = "ext4";
      "/boot".device = "/dev/disk/by-uuid/44A3-0B54";
      "/boot".fsType = "vfat";
    };

    #hardware = {
      #bluetooth.enable = true;
      #cpu.intel.updateMicrocode = true;
      #nvidia.modesetting.enable = true;
      #opengl.driSupport32Bit = true;
      #opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
      #pulseaudio.extraModules = [ pkgs.pulseaudio-modules-bt ];
    #};

    home-manager = {
      users.starlord = import ./home/home.nix { inherit pkgs machine; };
    };

    networking = {
      hostName = name;
      wireless.enable = true;
      wireless.networks.Cyberlink50.psk = "allyourbasearebelongstous";
      wireless.networks.Strandhyddan.psk = "8972524000";
      wireless.networks.RCO.psk = "logonrcowlan";
    };

    #powerManagement = {
    #  cpuFreqGovernor = pkgs.lib.mkDefault "powersave";
    #};

    services = {
      xserver.dpi = 180;
      xserver.libinput.enable = true;
      #xserver.videoDrivers = [ "modesetting" "nvidia" ];
      #upower.enable = true;
    };

    sound = {
      enable = true;
    };

    swapDevices = [ ];
  };

  desktop = { name, nodes, pkgs, ... }:
  let machine = ./home + "/${name}";
  in
  {
    # The name and nodes parameters are supported in Colmena,
    # allowing you to reference configurations in other nodes.
    networking = {
      hostName = name;
    };

    deployment = {
      allowLocalDeployment = true;
    };

    boot = {
      extraModulePackages = [ ];
      kernelModules = [ "kvm-amd" ];
      supportedFilesystems = [ "ntfs" ];
      loader.grub = {
        enable = true;
        version = 2;
        efiSupport = true;
        device = "nodev";
        useOSProber = true;
        configurationLimit = 2;
        efiInstallAsRemovable = true;
      };
      initrd = {
        availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
        kernelModules = [ ];
      };
    };

    fileSystems = {
      "/" = {
        device = "/dev/disk/by-uuid/c1bc882d-b3c6-476a-854e-f061ff0c03ab";
        fsType = "ext4";
      };

      "/boot" = {
        device = "/dev/disk/by-uuid/F38E-40DF";
        fsType = "vfat";
      };
    };

    swapDevices = [
      { device = "/dev/disk/by-uuid/66b5dece-00fa-4597-be57-25463e568631"; }
    ];

    services = {
      xserver = {
        dpi = 100;
        videoDrivers = [ "nvidia" ];
      };
    };

    home-manager.users.starlord = import ./home/home.nix { inherit pkgs machine; };
  };
}
