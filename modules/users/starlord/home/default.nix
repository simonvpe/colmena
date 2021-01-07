{ config, pkgs }:

let chitubox = pkgs.callPackage ./apps/chitubox.nix {};
    background = builtins.fetchurl { url = "https://i.redd.it/s8y93ms62r961.jpg"; };

in
{
  home.stateVersion = "20.03";

  home.packages = with pkgs; [
     alacritty          # Needed for the screensaver
     #chitubox
     cmatrix            # matrix stuff for thelock screen
     cq-editor          # cadquery, CAD software
     direnv
     discord
     docker
     fd                 # like find but better
     google-cloud-sdk   # GCP CLI
     googler            # Googles in the console
     i3blocks           # status bar for i3
     iftop              # shows active network connections
     jq                 # like sed for json
     linuxPackages.perf # performance monitor applications
     nload              # show network transfer load
     powerline-fonts    # we like fonts
     ripgrep            # like grep, but better
     spotify            # music!
     strace             # trace what applications do
     sysstat            # sar and more
     tree               # a nice util to show file trees
     tuir               # terminal UI for reddit
     up                 # A tool for writing Linux pipes with instant live preview
     xautolock          # automatic lock screen
     xorg.xkbcomp       # needed for custom keyboard maps
     xtrlock-pam        # a simple lock screen
  ];

  xsession = {
    enable = true;
    windowManager = {
      i3.enable = true;
      i3.package = pkgs.i3-gaps;
      i3.config = null;
      i3.extraConfig = import ./cfg/i3.nix { inherit config pkgs background; };
    };
  };

  programs.git = {
    enable = true;
    userName = "Simon Pettersson";
    userEmail = "simon.v.pettersson@gmail.com";
  };

  programs.bash = {
    bashrcExtra = "";
  };

  programs.termite = {
    enable = true;
    backgroundColor = "rgba(0, 0, 0, 0.5)";
  };

  programs.rofi = {
    enable = true;
    theme = "c64";
    terminal = "${pkgs.termite}/bin/termite";
  };

  programs.htop = {
    enable = true;
  };

  programs.firefox = {
    enable = true;
    # https://gitlab.com/rycee/nur-expressions/-/blob/master/pkgs/firefox-addons/addons.json
   extensions = with pkgs.nur.repos.rycee.firefox-addons; [
     bitwarden
     privacy-badger
#     vim-vixen
#     adsum-notabs
   ];
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

  programs.home-manager = {
    enable = true;
  };

  programs.bash = {
    enable = true;
    initExtra = ''
      # use bat as man pager for some colors
      export MANPAGER="sh -c 'col -b | bat -l man -p'"
      export EDITOR=nvim
      eval "$(direnv hook bash)"
      (cat ~/.cache/wal/sequences &)
      source ~/.cache/wal/colors-tty.sh
    '';
    shellAliases = {
      "cat" = "bat";
      ".."  = "cd ..";
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
    settings = {
      prompt_order = [
        "username"
        "directory"
        "git_branch"
        "kubernetes"
        "nodejs"
        "python"
      ];
    };
  };

  # bat, a cat clone with wings
  programs.bat = {
    enable = true;
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withPython3 = true;
    extraPython3Packages = (ps: with ps; [
      python-language-server
      pylint
      pep8
    ]);
    withNodeJs = true;
    plugins = with pkgs.vimPlugins; [
      # The rest
      ale
      fzf-vim                   # A command-line fuzzy finder
      indentLine                # A vim plugin to display the indention levels with thin vertical lines
      rainbow_parentheses       # Simpler Rainbow Parentheses
      semshi                    # Semantic Highlighting for Python in Neovim
      vim-airline               # lean & mean status/tabline for vim that's light as air
      vim-better-whitespace     # Better whitespace highlighting for Vim
      vim-commentary            # Comment stuff out
      vim-eunuch                # Helpers for UNIX
      vim-fugitive              # A Git wrapper so awesome, it should be illegal
      vim-hoogle                # Vim plugin used to query hoogle
      vim-nix                   # Vim configuration files for Nix
      vim-sensible              # Defaults everyone can agree on
      vim-signify               # Show a diff using Vim its sign column
      vim-surround              # Quoting/parenthesizing made simple
      wal-vim                   # Use pywal color theme
    ];
    extraConfig = ''
      " General settings
      colorscheme wal
      syntax on
      set number relativenumber
      set ff=unix
      set tabstop=4
      set shiftwidth=4
      set expandtab
      set cursorline
      set list
      set listchars=tab:>-
      set noswapfile
      set nobackup
      " Ripgrep and Fzf bindings
      nnoremap <C-b> :Buffers<Cr>
      nnoremap <C-t> :Files<Cr>
      nnoremap <C-h> :Rg<Cr>
      nnoremap <C-l> :BLines<Cr>
      nnoremap <C-L> :Lines<Cr>
      " Setup rainbow_parentheses
      au VimEnter * RainbowParenthesesToggle
      au Syntax * RainbowParenthesesLoadRound
      au Syntax * RainbowParenthesesLoadSquare
      au Syntax * RainbowParenthesesLoadBraces
      " Whitespace settings
      let g:strip_whitespace_on_save = 1
      let g:strip_whitespace_confirm = 0
    '';
  };


  programs.zathura = {
    enable = true;
  };

  home.file.".config/i3blocks/config".source = pkgs.writeText "i3blocks" (import ./cfg/i3blocks.nix { inherit config pkgs; });
  # home.file.".local/bin/lock".source = ./bin/lock;
  # home.file.".local/bin/keyboard".source = ./bin/keyboard;
  home.file.".xkb/symbols/svorak".source = ./keyboard/svorak;
  home.file.".xkb/symbols/evorak".source = ./keyboard/evorak;
}
