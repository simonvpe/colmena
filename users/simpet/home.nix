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

    home.file.".config/autorandr/default/config".text = ''
      output HDMI-2
      off
      output VGA-1
      crtc 0
      mode 1920x1080
      pos 1920x0
      primary
      rate 60.00
      output HDMI-1
      crtc 1
      mode 1920x1080
      pos 0x0
      rate 60.00
    '';

    home.file.".config/autorandr/default/setup".text = ''
      HDMI-1 00ffffffffffff004c2dcb095438585a0619010380351e782a4ba1a359559b260e5054bfef80714f81c0810081809500a9c0b3000101023a801871382d40582c4500132b2100001e000000fd00384b1e5111000a202020202020000000fc00533234433435300a2020202020000000ff00485450473230303735350a202001ea02010400023a80d072382d40102c4580132b2100001e011d007251d01e206e285500132b2100001e011d00bc52d01e20b8285540132b2100001e8c0ad090204031200c405500132b210000188c0ad08a20e02d10103e9600132b210000180000000000000000000000000000000000000000000000000000000000000000000e
      VGA-1 00ffffffffffff004c2d7f0c4b485a5a321a01030e341d782a2cc1a45650a1280f5054bfef80714f81c0810081809500a9c0b3000101023a801871382d40582c450009252100001e000000fd00384b1e5111000a202020202020000000fc00533234453435300a2020202020000000ff0048345a484330313330390a20200085
    '';
  };

}
