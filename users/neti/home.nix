{ config, pkgs, lib, age, ... }:
# let
#   inherit (config.home.sessionVariables) XDG_RUNTIME_DIR;
# in
{
  config = {
    programs.git.userName = "Simon Pettersson";
    programs.git.userEmail = "simpet@netinsight.net";
    programs.ssh.extraConfig = "Include ~/.ssh/config.neti";
    programs.teams.enable = true;
    programs.qtcreator.enable = true;
    programs.autorandr = {
      enable = true;
      profiles = {
        office = {
          fingerprint = {
            eDP-1 = "00ffffffffffff004c83474100000000261d0104b51d11780238d1ae513bb8230b505400000001010101010101010101010101010101b9d50040f17020803020880026a51000001bb9d50040f17020803020880026a51000001b0000000f00ff093cff093c2c800000000000000000fe0041544e413333545031312d312001a302030f00e3058000e6060501736d0700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ab";
            DP-1-2 = "00ffffffffffff0012b3002701000000101f0104a53c21783babb0ab5047a322115054a54b00714081c081809500a9c0b300d1c0d100565e00a0a0a029503020350055502100001a023a801871382d40582c4500b9882100001a000000fd00304b73733c010a202020202020000000fc004432375150550a20202020202001b3020317f14a9005040302011f1312112309070783010000bb7600a0a0a0325030403500c48f2100001a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000031";
            DP-1-3 = "00ffffffffffff0012b3002701000000101f0104a53c21783babb0ab5047a322115054a54b00714081c081809500a9c0b300d1c0d100565e00a0a0a029503020350055502100001a023a801871382d40582c4500b9882100001a000000fd00304b73733c010a202020202020000000fc004432375150550a20202020202001b3020317f14a9005040302011f1312112309070783010000bb7600a0a0a0325030403500c48f2100001a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000031";
          };
          config = {
            DP-1-2 = {
              enable = true;
              crtc = 1;
              primary = true;
              position = "3840x0";
              mode = "2560x1440";
              rotate = "left";
              rate = "60.00";
            };
            DP-1-3 = {
              enable = true;
              crtc = 2;
              primary = false;
              position = "5280x0";
              mode = "2560x1440";
              rotate = "right";
              rate = "60.00";
            };

          };
        };
      };
    };
    age = {
      enable = true;
      uid = 1002;
      identities = [ ".ssh/id_ed25519" ];
      recipients = {
        hyperactivitydrive = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBl0x0lHyufCLVvRnyXoNQ+yokV+EwKFn+qkGpELGdo1 neti@hyperactivitydrive";
        battlestation = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF2olFcrre8xXEGuQIUauzQFiVfDzsGpsv5yLX4691Ud neti@battlestation";
      };
      secrets.".ssh/id_ed25519.neti".inputPath = "${./secrets}/id_ed25519.neti.age";
      secrets.".ssh/id_ed25519.neti.pass".inputPath = "${./secrets}/id_ed25519.neti.pass.age";
      secrets.".ssh/config.neti".inputPath = "${./secrets}/ssh.config.neti.age";
      secrets.".config/vpn.config".inputPath = "${./secrets}/vpn.config.age";
    };
    home.file.".ssh/id_ed25519.neti.pub".source = ../public-keys/id_ed25519.neti.pub;

    services.ssh-agent = {
      enable = true;
      uid = 1002;
      keys = [
        {
          key = ".ssh/id_ed25519.neti";
          passphrase = ".ssh/id_ed25519.neti.pass";
        }
      ];
    };
    systemd.user.startServices = true;

    systemd.user.mounts.home-neti-hosts-delia = {
      Unit.Description = "Mount delia over sshfs with fuse";
      Unit.After = [ "age.service" "openfortivpn-1.service" "ssh-agent.service" ];
      Unit.Requires = [ "age.service" "openfortivpn-1.service" "ssh-agent.service" ];
      Install.WantedBy = [ "default.target" ];
      Mount.What = "delia:/home/simpet/projects";
      Mount.Where = "/home/neti/hosts/delia";
      Mount.Type = "fuse.sshfs";
      Mount.Options = lib.concatStringsSep "," [
        "_netdev"
        "default_permissions"
        "IdentityFile=/home/neti/.ssh/id_ed25519.neti"
        "reconnect"
        "x-systemd"
        "uid=1002"
        "gid=100"

        # We're already on an encrypted vpn so we don't really need more encryption than that
        # "Ciphers=arcfour"

        # Disable compression for speed
        "Compression=no"

        # Enable local caching
        "auto_cache"
      ];
    };

    systemd.user.automounts.home-neti-hosts-delia = {
      Unit.Description = "Automount delia over sshfs with fuse";
      Automount.Where = config.systemd.user.mounts.home-neti-hosts-delia.Mount.Where;
      Install.WantedBy = [ "default.target" ];
    };

    services.lorri.enable = true;
  };
}
