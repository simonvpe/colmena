{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.home-manager.url = "github:nix-community/home-manager/release-21.05";
  inputs.nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  inputs.nix-top.url = "github:samueldr/nix-top/v0.2.0";
  inputs.nix-top.flake = false;

  outputs = { self, nixpkgs, home-manager, nixos-hardware, nix-top }:
    let
      modules = {
        simux = ./modules;
        laptop-hardware = nixos-hardware.nixosModules.dell-xps-15-9500-nvidia;
        #laptop-hardware = nixos-hardware.nixosModules.dell-xps-15-9500;
        not-detected = "${nixpkgs.outPath}/nixos/modules/installer/scan/not-detected.nix";
        home-manager = home-manager.nixosModules.home-manager;
        home-manager-cfg = {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        };
      };

      legacyPkgs = import nixpkgs.outPath {
        system = "x86_64-linux";
        overlays = [ (_: super: { stdenv = super.stdenv // { inherit (super) lib; }; }) ];
      };

    in
    {
      nixosConfigurations.hyperactivitydrive = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules =
          [
            ({ pkgs, ... }: {
              system.stateVersion = "21.11"; # Did you read the comment?
              system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;

              imports = [
                modules.simux
                #modules.laptop-hardware
                modules.not-detected
                modules.home-manager
                modules.home-manager-cfg
              ];

              environment.systemPackages = [
                (import nix-top { pkgs = legacyPkgs; })
              ];

              users.users.root.initialHashedPassword = "";

              simux = {
                rco.enable = false;
                users.starlord.enable = true;
                users.starlord.enableHomeManager = true;
                wifi.device = "wlo1";
                wifi.enable = true;
                workstation.enable = true;
              };

	      nix.package = pkgs.nixUnstable;
              nix.sandboxPaths = [ "/bin/sh=${pkgs.bash}/bin/sh" ];
              nix.extraOptions = ''
                experimental-features = nix-command flakes
              '';

              networking = {
                hostName = "hyperactivitydrive";
                enableIPv6 = true;
                wireless.interfaces = [ "wlo1" ];
              };

              boot.loader.grub.enable = true;
              boot.loader.grub.configurationLimit = 2;
              boot.loader.grub.device = "nodev";
              boot.loader.grub.efiInstallAsRemovable = false;
              boot.loader.grub.efiSupport = true;
              boot.loader.grub.useOSProber = true;
              boot.loader.grub.version = 2;
              boot.loader.efi.canTouchEfiVariables = true;
              boot.supportedFilesystems = [ "ntfs" ];
              boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "vmd" "nvme" ];
              boot.initrd.kernelModules = [ ];
              boot.kernelModules = [ "kvm-intel" ];
              boot.extraModulePackages = [ ];

              fileSystems."/" = {
                device = "/dev/disk/by-uuid/506c69ff-c136-4e26-ba53-66f63f14be11";
                fsType = "ext4";
              };

              fileSystems."/boot" = {
                device = "/dev/disk/by-uuid/60C5-10BF";
                fsType = "vfat";
              };

              swapDevices = [ ];

              powerManagement.cpuFreqGovernor = pkgs.lib.mkDefault "powersave";

              hardware.video.hidpi.enable = pkgs.lib.mkDefault true;

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
