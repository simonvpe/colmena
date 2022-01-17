{ config, pkgs, lib, age, ... }:
{
  config = let uid = 1385; in {
    programs.git.userName = "Simon Pettersson";
    programs.git.userEmail = "simpet@netinsight.net";
    programs.ssh.enable = true;
    programs.ssh.extraConfig = "Include ~/.ssh/config.simpet";
    age = {
      inherit uid;
      enable = true;
      # Encrypted with the local key on delia (protected with a passphrase to not
      # have neti IT department have access to all my secrets)
      identities = [ ".ssh/id_ed25519.delia" ];
      # Decryption is allowed by the starlord user, or if you have physical access
      # to the delia machine + the passphrase
      recipients = {
        delia = builtins.readFile "${../public-keys/id_ed25519.delia.pub}";
        starlord = builtins.readFile "${../public-keys/id_ed25519.starlord.pub}";
      };
      secrets.".ssh/config.simpet" = {
        owner = builtins.toString uid;
        inputPath = "${./secrets}/ssh.config.simpet.age";
      };
      secrets.".ssh/id_ed25519.simpet" = {
        owner = builtins.toString uid;
        inputPath = "${./secrets}/id_ed25519.simpet.age";
      };
    };
    home.file.".ssh/id_ed25519.simpet.pub".source = ../public-keys/id_ed25519.simpet.pub;

    services.ssh-agent = {
      inherit uid;
      enable = true;
      keys = [
        { key = ".ssh/id_ed25519.simpet"; }
      ];
    };
    systemd.user.startServices = true;

    home.file.".bash_profile".text = ''
      if [ -f ~/.bashrc ]; then
        . ~/.bashrc
      fi
    '';

    # neither alacritty nor kitty works on non NixOs hosts
    terminal.package = lib.mkForce pkgs.termite;
  };

}
