{ config, lib, pkgs, ... }:
with lib;
let cfg = config.simux.workstation;
in
{
  options.simux.workstation = {
    enable = mkEnableOption "workstation mode";
  };

  config = {
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
}
