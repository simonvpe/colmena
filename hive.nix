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
      ./modules
    ];
  };

  laptop = { name, nodes, pkgs, ... }:
  {
    imports = [
      <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
      "${external.nixos-hardware}/dell/xps/15-9500/nvidia"
    ];

    simux = {
      battery.device = "BAT0";
      battery.enable = true;
      rco.enable = true;
      users.starlord.enable = true;
      users.starlord.enableHomeManager = true;
      wifi.device = "wlp59s0";
      wifi.enable = true;
      workstation.enable = true;
    };

    networking = {
      hostName = name;
    };

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


    fileSystems = {
      "/".device = "/dev/disk/by-uuid/4c8e4486-331f-4963-9fa9-6800109beca9";
      "/".fsType = "ext4";
      "/boot".device = "/dev/disk/by-uuid/44A3-0B54";
      "/boot".fsType = "vfat";
    };


    swapDevices = [ ];

    services = {
      xserver.dpi = 180;
      xserver.libinput.enable = true;
    };
  };

  desktop = { name, nodes, pkgs, ... }:
  {
    imports = [
      <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

    simux = {
      cuda.enable =true;
      gaming.enable = true;
      hydra.enable = true;
      rco.enable = true;
      users.starlord.enable = true;
      users.starlord.enableHomeManager = true;
      workstation.enable = true;
    };

    networking = {
      hostName = name;
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
      xserver.dpi = 100;
      xserver.videoDrivers = [ "nvidia" ];
    };
  };
}
