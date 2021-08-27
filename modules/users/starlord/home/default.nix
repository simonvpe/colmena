{ config, pkgs }:
let
  # chitubox = pkgs.callPackage ./apps/chitubox.nix { };
  background = pkgs.fetchurl {
    url = "https://i.redd.it/dy9xn211uo861.jpg";
    sha256 = "0xd1iaddcfryf6q69j4jy2ypbgq09fh5iynw2a2hi7608r48fxk0";
  };

in
{
  home.stateVersion = "20.03";

  home.packages = with pkgs; [
    #chitubox
    alacritty # Needed for the screensaver
    cmatrix # matrix stuff for thelock screen
    #cq-editor # cadquery, CAD software
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
    siji # An iconic bitmap font based on Stlarch with additional glyphs
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
    krita

    irssi # irc
    # TODO:
    # https://github.com/Canop/broot
    #(pkgs.callPackage ../../../apps/koka.nix {})
    nix-diff
    font-awesome
  ];

  xsession =
     let
       bl = "/sys/class/backlight/intel_backlight";
       backlight = {
         increase = pkgs.writeTextFile {
	   name = "backlight-increase";
           executable = true;
           text =  ''
             echo USER=$USER
             echo $(( $(cat ${bl}/brightness) + $(cat ${bl}/max_brightness) / 10 )) > ${bl}/brightness
             cat ${bl}/brightness
           '';
         };
         decrease = pkgs.writeTextFile {
           name = "backlight-decrease";
           executable = true;
           text = ''
             echo USER=$USER
             echo $(( $(cat ${bl}/brightness) - $(cat ${bl}/max_brightness) / 10 )) > ${bl}/brightness
             cat ${bl}/brightness
           '';
         };
       };
     in {
       enable = true;
       windowManager = {
         i3.enable = true;
         i3.package = pkgs.i3-gaps;
         i3.config = null;
         i3.extraConfig = import ./cfg/i3.nix { inherit config pkgs background backlight; };
       };
     };

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

  programs.firefox = {
    enable = true;
    # https://gitlab.com/rycee/nur-expressions/-/blob/master/pkgs/firefox-addons/addons.json
   # extensions = with pkgs.nur.repos.rycee.firefox-addons; [
   #   bitwarden
  # #     privacy-badger
  # #     vim-vixen
  # #     adsum-notabs
   # ];
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

  #   programs.home-manager = {
  #     enable = true;
  #   };

  programs.bash = {
    enable = true;
    initExtra = ''
      # use bat as man pager for some colors
      export MANPAGER="sh -c 'col -b | bat -l man -p'"
      export EDITOR=nvim
      eval "$(direnv hook bash)"
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

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withPython3 = true;
    extraPython3Packages = (ps: with ps; [
      #python-language-server
      pylint
      pep8
    ]);
    withNodeJs = false;
    plugins = with pkgs.vimPlugins; [
      # The rest
      ale
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
      vim-sleuth
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

  services.polybar = rec {
    enable = true;
    package = (pkgs.polybar.override {
      i3GapsSupport = true;
      i3 = pkgs.i3-gaps;
      alsaSupport = true;
      githubSupport = true;
      pulseSupport = true;
    }).overrideAttrs (x: {
      cmakeFlags = (x.cmakeFlags or [ ]) ++ [
        "-DENABLE_I3=ON"
      ];
    });
    script = ''
      export PATH=${pkgs.xorg.xrandr}/bin:${pkgs.gnugrep}/bin:${pkgs.coreutils}/bin:$PATH
      for monitor in $(xrandr --query | grep " connected" | cut -d' ' -f1); do
        MONITOR=$monitor ${package}/bin/polybar top &
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
        modules-right = "bluetooth cpu pulseaudio wireless-network battery backlight date";
        module-margin = "5";
        font-0 = "Bitstream Vera Serif:pixelsize=20;3";
        font-1 = "Font Awesome 5 Free:style=regular:pixelsize=20;3";
        font-2 = "Font Awesome 5 Free:style=solid:pixelsize=20;3";
        font-3 = "Font Awesome 5 Brands:style=solid:pixelsize=20;3";
        font-4 = "Font Awesome 5 Brands:style=regular:pixelsize=20;3";
      };
      "module/bluetooth" = let bt = pkgs.callPackage ./bluetooth.nix {}; in {
        type = "custom/script";
        exec = "${bt}/bin/polybar-bluetooth.sh";
        interval = 2;
        click-left = "exec ${pkgs.blueberry}/bin/blueberry";
        click-right = "exec ${bt}/bin/toggle-bluetooth.sh";
        format-padding = "1";
        format-background = "#000000";
        format-foreground = "#ffffff";
      };
      "module/cpu" = {
        type = "internal/cpu";
        interval = "0.5";
        format = "<label>";
        label = " %percentage%%";
      };
      "module/pulseaudio" = {
        type = "internal/pulseaudio";
        sink = "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi___ucm0001.hw_sofhdadsp__sink";
        use-ui-max = true;
        interval = 5;
        format-volume = "<label-volume>";
        format-muted = "<label-muted>";
        label-volume = " %percentage%%";
        label-muted = " 0%";
      };
      "module/backlight" = {
        type = "internal/backlight";
        card = "intel_backlight";
        use-actual-brightness = true;
        enable-scroll = true;
        format = "<label>";
        label = " %percentage%%";
      };
      "module/wireless-network" = {
        type = "internal/network";
        interface = "wlo1";
        label-connected = " %essid% %downspeed:9%";
        label-connected-foreground = "#eefafafa";
        label-disconnected = " not connected";
        label-disconnected-foreground = "#66ffffff";
      };
      "module/battery" = {
        type = "internal/battery";
        full-at = "99";
        battery = "BAT0";
        adapter = "AC0";
        poll-interval = "5";
        format-charging = "<animation-charging> <label-charging>";
        format-discharging = "<animation-discharging> <label-discharging>";
        format-full = "<ramp-capacity> <label-full>";
        label-charging = "%percentage%%";
        label-discharging = "%percentage%%";
        label-full = " Fully charged";
        ramp-capacity-0 = "";
        ramp-capacity-1 = "";
        ramp-capacity-2 = "";
        ramp-capacity-3 = "";
        ramp-capacity-4 = "";
        bar-capacity-width = "10";
        animation-charging-0 = "";
        animation-charging-1 = "";
        animation-charging-2 = "";
        animation-charging-3 = "";
        animation-charging-4 = "";
        animation-charging-framerate = "750";
        animation-discharging-0 = "";
        animation-discharging-1 = "";
        animation-discharging-2 = "";
        animation-discharging-3 = "";
        animation-discharging-4 = "";
        animation-discharging-framerate = "500";
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
  home.file.".config/libinput-gestures.conf".source = pkgs.callPackage ./cfg/libinput.nix {};
  # home.file.".python-gitlab.cfg".source = ./python-gitlab/.python-gitlab.cfg;
}
