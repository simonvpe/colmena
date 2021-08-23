{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.home-manager.url = "github:nix-community/home-manager/release-21.05";
  inputs.nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  inputs.nix-top.url = "github:samueldr/nix-top/v0.2.0";
  inputs.nix-top.flake = false;

  outputs = { self, nixpkgs, home-manager, nixos-hardware, nix-top }:
    let
      apps = {
        nix-top = import nix-top { pkgs = legacyPkgs; };
      };
      modules = {
        system = hostname: { pkgs, ... }: {
          imports = [
            "${nixpkgs.outPath}/nixos/modules/installer/scan/not-detected.nix"
          ];
          system.stateVersion = "21.11";
          system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
          users.users.root.initialHashedPassword = "";
          nixpkgs.config.allowUnfree = true;
          nix.package = pkgs.nixUnstable;
          nix.sandboxPaths = [ "/bin/sh=${pkgs.bash}/bin/sh" ];
          nix.extraOptions = "experimental-features = nix-command flakes";
          networking.hostName = hostname;
          networking.enableIPv6 = true;
          networking.useNetworkd = true;
          networking.useDHCP = false; # cannot be used together with networkd
          time.timeZone = "Europe/Stockholm";
          hardware.pulseaudio.enable = true;
          hardware.opengl.driSupport32Bit = true;
          services.openssh.enable = true;
          console.font = "Lat2-Terminus16";
          console.keyMap = "dvorak";
          i18n.defaultLocale = "en_US.UTF-8";
          virtualisation.docker.enable = true;
          virtualisation.docker.enableOnBoot = true;
          virtualisation.libvirtd.enable = true;
          sound.enable = true;
          services.xserver.enable = true;
          services.xserver.layout = "dvorak";
          services.xserver.xkbVariant = "pc102";
          services.xserver.xkbOptions = "caps:swapescape lv3:ralt_switch";
          services.xserver.displayManager.lightdm.enable = true;
          services.xserver.displayManager.defaultSession = "none+i3";
          services.xserver.desktopManager.xterm.enable = true;
          services.xserver.windowManager.i3.enable = true;
          fonts.fontDir.enable = true;
          fonts.enableGhostscriptFonts = true;
          fonts.fonts = with pkgs; [
            corefonts
            ttf_bitstream_vera
            emojione
            noto-fonts
            noto-fonts-emoji
            roboto
            font-awesome-ttf
          ];
          fonts.fontconfig.defaultFonts = {
            serif = [ "Bitstream Vera Sans" "EmojiOne Color" "Font Awesome 5 Free" ];
            sansSerif = [ "Bitstream Vera Serif" "EmojiOne Color" "Font Awesome 5 Free" ];
            monospace = [ "Bitstream Vera Sans Mono" "EmojiOne Color" "Font Awesome 5 Free" ];
          };
          environment.systemPackages = with pkgs; [
            curl
            git
            nodePackages.bitwarden-cli
            ntfs3g
            vim
            wget
            apps.nix-top
          ];
          environment.pathsToLink = [ "/libexec" ];
        };
        wifi = device: {
          imports = [(import ./modules/wifi { inherit device; })];
        };
        users = {
          imports = [
            home-manager.nixosModules.home-manager
            (import ./modules/users/starlord {})
            (import ./modules/users/rco {})
          ];
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
            (modules.system "hyperactivitydrive")
            (modules.wifi "wlo1")
            #nixos-hardware.nixosModules.asus-zenbook-ux371
            modules.users
            ({ pkgs, ... }: {
              boot.loader.grub.enable = true;
              boot.loader.grub.configurationLimit = 2;
              boot.loader.grub.device = "nodev";
              boot.loader.grub.efiInstallAsRemovable = false;
              boot.loader.grub.efiSupport = true;
              boot.loader.grub.useOSProber = true;
              boot.loader.grub.version = 2;
              boot.loader.efi.canTouchEfiVariables = true;
              boot.loader.efi.efiSysMountPoint = "/boot";
              boot.supportedFilesystems = [ "ntfs" ];
              boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "vmd" "nvme" ];
              boot.initrd.kernelModules = [ ];
              boot.kernelModules = [ "kvm-intel" ];
              boot.extraModulePackages = [ ];

              systemd.services.battery-charge-threshold = {
                wantedBy = [ "multi-user.target" ];
                after = [ "multi-user.target" ];
                description = "Set the battery charge threshold";
                startLimitBurst = 60;
                serviceConfig = {
                  Type = "oneshot";
                  Restart = "on-failure";
                  ExecStart = "/bin/sh -c 'echo 80 > /sys/class/power_supply/BAT0/charge_control_end_threshold'";
                };
              };

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
                xserver.displayManager.sessionCommands = ''
                  ${pkgs.xorg.xrdb}/bin/xrdb -merge <<EOF
                    Xcursor.theme: Adwaita
                    Xcursor.size: 48
                  EOF
                '';
                xserver.dpi = 180;
                xserver.libinput.enable = true;
              };


            })
          ];
      };

      #nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
      #  system = "x86_64-linux";
      #  modules =
      #    [
      #      ({ pkgs, ... }: {
      #        # Let 'nixos-version --json' know about the Git revision
      #        # of this flake.
      #        system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;

      #        imports = [
      #          ./modules
      #          "${nixpkgs.outPath}/nixos/modules/installer/scan/not-detected.nix"
      #          home-manager.nixosModules.home-manager
      #          {
      #            home-manager.useGlobalPkgs = true;
      #            home-manager.useUserPackages = true;
      #          }
      #        ];

      #        environment.systemPackages = [
      #          pkgs.cntr
      #        ];

      #        nix.sandboxPaths = [ "/bin/sh=${pkgs.bash}/bin/sh" ];

      #        # nix.binaryCaches = [ "https://cache.nixos.org" "https://hydra.iohk.io" ];
      #        # nix.trustedBinaryCaches = [ "https://hydra.iohk.io" ];
      #        # nix.binaryCachePublicKeys = [ "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=" ];
      #        nix.requireSignedBinaryCaches = false;

      #        simux = {
      #          cuda.enable = false;
      #          flakes.enable = true;
      #          gaming.enable = false;
      #          hydra.enable = false; # broken right now
      #          rco.enable = true;
      #          users.starlord.enable = true;
      #          users.starlord.enableHomeManager = true;
      #          workstation.enable = true;
      #        };

      #        # For building for raspberry pi
      #        #boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

      #        networking = {
      #          hostName = "desktop";
      #          enableIPv6 = true;
      #          interfaces.enp4s0.tempAddress = "enabled";
      #        };

      #        boot = {
      #          extraModulePackages = [ ];
      #          kernelModules = [ "kvm-amd" ];
      #          supportedFilesystems = [ "ntfs" ];
      #          loader.grub = {
      #            enable = true;
      #            version = 2;
      #            efiSupport = true;
      #            device = "nodev";
      #            useOSProber = true;
      #            configurationLimit = 2;
      #            efiInstallAsRemovable = true;
      #          };
      #          initrd = {
      #            availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
      #            kernelModules = [ ];
      #          };
      #        };

      #        fileSystems = {
      #          "/" = {
      #            device = "/dev/disk/by-uuid/c1bc882d-b3c6-476a-854e-f061ff0c03ab";
      #            fsType = "ext4";
      #          };

      #          "/boot" = {
      #            device = "/dev/disk/by-uuid/F38E-40DF";
      #            fsType = "vfat";
      #          };
      #        };

      #        swapDevices = [
      #          { device = "/dev/disk/by-uuid/66b5dece-00fa-4597-be57-25463e568631"; }
      #        ];

      #        services = {
      #          xserver.dpi = 100;
      #          xserver.videoDrivers = [ "nvidia" ];
      #        };
      #      })
      #    ];
      #};
    };
}
