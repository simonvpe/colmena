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
      Unit.After = [ "age.service" "openfortivpn-1.service" "ssh-agent.service"];
      Unit.Requires = [ "age.service" "openfortivpn-1.service" "ssh-agent.service"];
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
  };
}
