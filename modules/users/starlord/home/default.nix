{ config, pkgs }:
let
  chitubox = pkgs.callPackage ./apps/chitubox.nix { };
  background = builtins.fetchurl { url = "https://i.redd.it/dy9xn211uo861.jpg"; };

in
{
  home.stateVersion = "20.03";

  home.packages = with pkgs; [
    #chitubox
    alacritty # Needed for the screensaver
    cmatrix # matrix stuff for thelock screen
    cq-editor # cadquery, CAD software
    direnv
    #discord
    docker
    fd # like find but better
    google-cloud-sdk # GCP CLI
    googler # Googles in the console
    iftop # shows active network connections
    jq # like sed for json
    linuxPackages.perf # performance monitor applications
    nload # show network transfer load
    powerline-fonts # we like fonts
    python3Packages.python-gitlab # a cli for gitlab
    ripgrep # like grep, but better
    spotify # music!
    strace # trace what applications do
    sysstat # sar and more
    tree # a nice util to show file trees
    #tuir               # terminal UI for reddit
    up # A tool for writing Linux pipes with instant live preview
    xautolock # automatic lock screen
    xorg.xkbcomp # needed for custom keyboard maps
    xtrlock-pam # a simple lock screen

    irssi # irc
    # TODO:
    # https://github.com/Canop/broot
    #(pkgs.callPackage ../../../apps/koka.nix {})
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
    extraConfig = ''
      [alias]
      brd = !git for-each-ref --sort='-authordate:iso8601' --format=' %(authordate:iso8601)%09%(refname)' refs/heads | sed -e 's-refs/heads/--'
    '';
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
    theme = "~/.cache/wal/colors-rofi-dark.rasi";
    terminal = "${pkgs.termite}/bin/termite";
  };

  programs.htop = {
    enable = true;
  };

  # programs.firefox = {
  #   enable = true;
  #   # https://gitlab.com/rycee/nur-expressions/-/blob/master/pkgs/firefox-addons/addons.json
  #  extensions = with pkgs.nur.repos.rycee.firefox-addons; [
  #    bitwarden
  # #     privacy-badger
  # #     vim-vixen
  # #     adsum-notabs
  #  ];
  # };

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
      <<<<<<< HEAD
      fzf-vim # A command-line fuzzy finder
      indentLine # A vim plugin to display the indention levels with thin vertical lines
      rainbow_parentheses # Simpler Rainbow Parentheses
      semshi # Semantic Highlighting for Python in Neovim
      vim-airline # lean & mean status/tabline for vim that's light as air
      vim-better-whitespace # Better whitespace highlighting for Vim
      vim-commentary # Comment stuff out
      vim-eunuch # Helpers for UNIX
      vim-fugitive # A Git wrapper so awesome, it should be illegal
      vim-hoogle # Vim plugin used to query hoogle
      vim-nix # Vim configuration files for Nix
      vim-sensible # Defaults everyone can agree on
      vim-signify # Show a diff using Vim its sign column
      vim-surround # Quoting/parenthesizing made simple
      wal-vim # Use pywal color theme
      vim-sleuth # Automatically adapt to indentation style
      =======
      fzf-vim # A command-line fuzzy finder
      indentLine # A vim plugin to display the indention levels with thin vertical lines
      neoformat
      rainbow_parentheses # Simpler Rainbow Parentheses
      semshi # Semantic Highlighting for Python in Neovim
      vim-airline # lean & mean status/tabline for vim that's light as air
      vim-better-whitespace # Better whitespace highlighting for Vim
      vim-commentary # Comment stuff out
      vim-eunuch # Helpers for UNIX
      vim-fugitive # A Git wrapper so awesome, it should be illegal
      vim-hoogle # Vim plugin used to query hoogle
      vim-nix # Vim configuration files for Nix
      vim-sensible # Defaults everyone can agree on
      vim-signify # Show a diff using Vim its sign column
      vim-surround # Quoting/parenthesizing made simple
      wal-vim # Use pywal color theme
      >>>>>>> b3cd0fc
      (stuff)
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

      " Code formatting
      augroup fmt
        autocmd!
        autocmd BufWritePre * undojoin | Neoformat
      augroup END
    '';
  };


  programs.zathura = {
    enable = true;
  };

  services.polybar = {
    enable = true;
    package = (pkgs.polybar.override {
      i3GapsSupport = true;
      i3 = pkgs.i3-gaps;
      alsaSupport = true;
      githubSupport = true;
    }).overrideAttrs (x: {
      cmakeFlags = (x.cmakeFlags or [ ]) ++ [
        "-DENABLE_I3=ON"
      ];
    });
    script = ''
      export PATH=${pkgs.xorg.xrandr}/bin:${pkgs.gnugrep}/bin:${pkgs.coreutils}/bin:$PATH
      for monitor in $(xrandr --query | grep " connected" | cut -d' ' -f1); do
        MONITOR=$monitor polybar top &
      done
    '';
    config = {
      "colors" = {
        background = "\${xrdb:color0}";
        foreground = "\${xrdb:color7}";
        primary = "\${xrdb:color1}";
        secondary = "\${xrdb:color2}";
        alert = "${xrdb:color3}";
      };
      "bar/top" = {
        monitor = "\${env:MONITOR}";
        width = "100%";
        height = "1%";
        radius = 0;
        background = "\${colors.background}";
        foreground = "\${colors.foreground}";
        modules-left = "i3";
        modules-right = "date";
      };
      "module/date" = {
        type = "internal/date";
        interval = 1;
        date = "%Y-%m-%d";
        time = "%H:%M:%S";
        label = "%date% %time%";
      };
      "module/i3" = {
        type = "internal/i3";
        pin-workspaces = true;
        strip-wsnumbers = true;
        index-sort = true;
        enable-click = false;
        enable-scroll = false;
        wrapping-scroll = false;
        reverse-scroll = false;
        fuzzy-match = true;
        format = "<label-state> <label-mode>";
        label-mode = "%mode%";
        label-mode-padding = 2;
        label-mode-background = "#e60053";
        label-focused = "%index%";
        label-focused-foreground = "\${colors.secondary}";
        label-focused-background = "\${colors.background}";
        label-focused-underline = "\${colors.primary}";
        label-focused-padding = 0;
        label-unfocused = "%index%";
        label-unfocused-padding = 0;
        label-separator = "|";
        label-separator-padding = 1;
        label-separator-foreground = "\${colors.primary}";
      };
    };
  };

  home.file.".xkb/symbols/svorak".source = ./keyboard/svorak;
  home.file.".xkb/symbols/evorak".source = ./keyboard/evorak;
  home.file.".python-gitlab.cfg".source = ./python-gitlab/.python-gitlab.cfg;
}
