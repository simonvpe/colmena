{ config, pkgs, lib, age, ... }:
{
  config = {
    programs.git.userName = "Simon Pettersson";
    programs.git.userEmail = "simpet@netinsight.net";
    programs.ssh.enable = true;
    programs.ssh.extraConfig = ''
      Host git
        IdentityFile ~/.ssh/id_ed25519
        User gitosis
        ForwardX11 no

      Host gaston0
          IdentityFile ~/.ssh/id_ed25519
          User root
          HostName gaston0.lab.netinsight.se
          ForwardX11 no

      Host gaston1
          IdentityFile ~/.ssh/id_ed25519
          User root
          HostName gaston1.lab.netinsight.se
          ForwardX11 no

      Host gaston2
          IdentityFile ~/.ssh/id_ed25519
          User root
          HostName gaston2.lab.netinsight.se
          ForwardX11 no

      Host gaston3
          IdentityFile ~/.ssh/id_ed25519
          User root
          HostName gaston3.lab.netinsight.se
          ForwardX11 no

      Host gaston4
          IdentityFile ~/.ssh/id_ed25519
          User root
          HostName gaston4.lab.netinsight.se
          ForwardX11 no

      Host gaston5
          IdentityFile ~/.ssh/id_ed25519
          User root
          HostName gaston5.lab.netinsight.se
          ForwardX11 no
    '';
    # programs.ssh.extraConfig = "Include ~/.ssh/config.neti";
    # age = {
    #   enable = true;
    #   uid = 1002;
    #   identities = [ ".ssh/id_ed25519" ];
    #   recipients = {
    #     hyperactivitydrive = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBl0x0lHyufCLVvRnyXoNQ+yokV+EwKFn+qkGpELGdo1 neti@hyperactivitydrive";
    #     battlestation = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF2olFcrre8xXEGuQIUauzQFiVfDzsGpsv5yLX4691Ud neti@battlestation";
    #   };
    #   secrets.".ssh/id_ed25519.neti".inputPath = "${./secrets}/id_ed25519.neti.age";
    #   secrets.".ssh/id_ed25519.neti.pass".inputPath = "${./secrets}/id_ed25519.neti.pass.age";
    #   secrets.".ssh/config.neti".inputPath = "${./secrets}/ssh.config.neti.age";
    #   secrets.".config/vpn.config".inputPath = "${./secrets}/vpn.config.age";
    # };
    # home.file.".ssh/id_ed25519.neti.pub".source = ../public-keys/id_ed25519.neti.pub;

    # services.ssh-agent = {
    #   enable = true;
    #   uid = 1002;
    #   keys = [
    #     {
    #       key = ".ssh/id_ed25519.neti";
    #       passphrase = ".ssh/id_ed25519.neti.pass";
    #     }
    #   ];
    # };
    # systemd.user.startServices = true;

    home.file.".bash_profile".text = ''
      if [ -f ~/.bashrc ]; then
        . ~/.bashrc
      fi
    '';
  };

}
