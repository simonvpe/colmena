{ config, pkgs, ... }:
# let
#   # chitubox = pkgs.callPackage ./apps/chitubox.nix { };
#   background = pkgs.fetchurl {
#     url = "https://i.redd.it/dy9xn211uo861.jpg";
#     sha256 = "0xd1iaddcfryf6q69j4jy2ypbgq09fh5iynw2a2hi7608r48fxk0";
#   };
#   inherit (pkgs) callPackage;

# in
{
  home.stateVersion = "20.03";

  imports = [
    ./fragments/i3
    ./fragments/keyboard
    ./fragments/polybar
    ./fragments/vim
  ];


  home.packages = with pkgs; [
    #cq-editor
    discord
    docker
    fd # like find but better
    font-awesome
    google-cloud-sdk # GCP CLI
    iftop # shows active network connections
    jq # like sed for json
    krita # painting
    linuxPackages.perf # performance monitor applications
    nix-diff
    nload # show network transfer load
    powerline-fonts # we like fonts
    ripgrep # like grep, but better
    siji # An iconic bitmap font based on Stlarch with additional glyphs
    spotify # music!
    strace # trace what applications do
    sysstat # sar and more
    tree # a nice util to show file trees
    up # A tool for writing Linux pipes with instant live preview
    xorg.xkbcomp # needed for custom keyboard maps
    conda
  ];

  programs.ssh.enable = true;
  programs.ssh.extraConfig = ''
    Host router
      HostName 192.168.1.1
      User root
  '';

  programs.git = {
    enable = true;
    userName = "Simon Pettersson";
    userEmail = "simon.v.pettersson@gmail.com";
    extraConfig = {
      alias = {
        brd = "!git for-each-ref --sort='-authordate:iso8601' --format=' %(authordate:iso8601)%09%(refname)' refs/heads | sed -e 's-refs/heads/--'";
      };
    };
  };

  programs.bash = {
    bashrcExtra = ''
      if [ -f ~/.bashrc-custom ]; then
        source ~/.bashrc-custom
      fi
    '';
  };

  programs.termite = {
    enable = true;
    backgroundColor = "rgba(0, 0, 0, 0.5)";
  };

  programs.rofi = {
    enable = true;
    theme = "~/.cache/wal/colors-rofi-dark.rasi";
    terminal = "${pkgs.termite}/bin/termite";
  };

  programs.htop = {
    enable = true;
  };

  programs.brave.enable = true;

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

  programs.home-manager.enable = true;

  programs.bash = {
    enable = true;
    initExtra = ''
      # use bat as man pager for some colors
      export MANPAGER="sh -c 'col -b | bat -l man -p'"
      export EDITOR=nvim
      export TERM=vt100
      printf '%s' "$(cat ~/.cache/wal/sequences)"
      source ~/.cache/wal/colors-tty.sh
    '';
    shellAliases = {
      "cat" = "bat";
      ".." = "cd ..";
      "google" = "googler";
    };
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = false;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = false;
    enableFishIntegration = false;
  };

  # bat, a cat clone with wings
  programs.bat = {
    enable = true;
  };

  # programs.zathura = {
  #   enable = true;
  # };

  #home.file.".config/libinput-gestures.conf".source = pkgs.callPackage ./cfg/libinput.nix {};
}
