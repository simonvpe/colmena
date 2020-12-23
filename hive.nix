let
  external = import ./external;
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

    nixpkgs = {
      config.allowUnfree = true;
    };

    hardware = {
      pulseaudio.enable = true;
      opengl.driSupport32Bit = true;
    };

    services = {
      resolved = {
        enable = true;
        fallbackDns = [ "1.1.1.1" "8.8.8.8" ];
      };

      nscd = {
        enable = true;
      };

      openssh = {
        enable = true;
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
  };

  laptop = { name, nodes, pkgs, ... }:
  let machine = ./home + "/${name}";
  in
  {
    imports = [
      <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
      "${external.nixos-hardware}/dell/xps/15-9500/nvidia"
      (import "${external.home-manager}/nixos")
      ./modules/rco
      ./modules/wifi
      ./modules/battery
      ./modules/users/starlord
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

    home-manager = {
      users.starlord = import ./home/home.nix { inherit pkgs machine; };
    };

    networking = {
      hostName = name;
    };

    services = {
      xserver.dpi = 180;
      xserver.libinput.enable = true;
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
    imports = [
      (import "${external.home-manager}/nixos")
      ./modules/rco
      ./modules/users/starlord
    ];

    sound = {
      enable = true;
    };

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
