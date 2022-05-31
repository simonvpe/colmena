# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./battery-charge-threshold.nix
      inputs.nixos-hardware.nixosModules.asus-zenbook-ux371
    ];

  # Use the systemd-boot EFI boot loader.
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

  # required from the wifi profile
  networking.wireless.interfaces = [ "wlo1" ];
  networking.interfaces.wlo1.useDHCP = true;

  hardware.video.hidpi.enable = pkgs.lib.mkDefault true;
  hardware.bluetooth.enable = true;
  hardware.sensor.iio.enable = true;
  hardware.firmware = with pkgs; [ sof-firmware ];

  services.xserver.displayManager.sessionCommands = ''
    ${pkgs.xorg.xrdb}/bin/xrdb -merge <<EOF
      Xcursor.theme: Adwaita
      Xcursor.size: 48
    EOF
  '';

  services.xserver.dpi = 200;
  services.xserver.libinput.enable = true;
  services.xserver.libinput.mouse.disableWhileTyping = true;
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness"
    ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
  '';
  services.thermald.enable = true;
  powerManagement.cpuFreqGovernor = "powersave";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

}
