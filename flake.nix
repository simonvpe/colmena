{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.home-manager.url = "github:nix-community/home-manager/release-21.05";
  inputs.nixos-hardware.url = "github:NixOS/nixos-hardware/master";

  outputs = { self, nixpkgs, home-manager, nixos-hardware }:
    let modules = {
      simux = ./modules;
      laptop-hardware = nixos-hardware.nixosModules.dell-xps-15-9500-nvidia;
      not-detected = "${nixpkgs.outPath}/nixos/modules/installer/scan/not-detected.nix";
      home-manager = home-manager.nixosModules.home-manager;
      home-manager-cfg = {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      };
    };
    in
    {
      nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules =
          [
            ({ pkgs, ... }: {
              system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;

              imports = [
                modules.simux
                modules.laptop-hardware
                modules.not-detected
                modules.home-manager
                modules.home-manager-cfg
              ];

              simux = {
                flakes.enable = true;
                rco.enable = true;
                users.starlord.enable = true;
                users.starlord.enableHomeManager = true;
                wifi.device = "wlp59s0";
                wifi.enable = true;
                workstation.enable = true;
              };

              boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

              networking = {
                hostName = "laptop";
                enableIPv6 = true;
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


            })
          ];
      };

      nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules =
          [
            ({ pkgs, ... }: {
              # Let 'nixos-version --json' know about the Git revision
              # of this flake.
              system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;

              imports = [
                ./modules
                "${nixpkgs.outPath}/nixos/modules/installer/scan/not-detected.nix"
                home-manager.nixosModules.home-manager
                {
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;
                }
              ];

              environment.systemPackages = [
                pkgs.cntr
              ];

              nix.sandboxPaths = [ "/bin/sh=${pkgs.bash}/bin/sh" ];

              # nix.binaryCaches = [ "https://cache.nixos.org" "https://hydra.iohk.io" ];
              # nix.trustedBinaryCaches = [ "https://hydra.iohk.io" ];
              # nix.binaryCachePublicKeys = [ "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=" ];
              nix.requireSignedBinaryCaches = false;

              simux = {
                cuda.enable = false;
                flakes.enable = true;
                gaming.enable = false;
                hydra.enable = false; # broken right now
                rco.enable = true;
                users.starlord.enable = true;
                users.starlord.enableHomeManager = true;
                workstation.enable = true;
              };

              # For building for raspberry pi
              #boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

              networking = {
                hostName = "desktop";
                enableIPv6 = true;
                interfaces.enp4s0.tempAddress = "enabled";
                interfaces.enp4s0.useDHCP = true;
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
            })
          ];
      };
    };
  }
