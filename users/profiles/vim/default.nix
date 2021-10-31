{ config
, pkgs
, ...
}:

{

  imports = [
    ./gitsigns.nix
    ./skim.nix
    ./lspconfig.nix
    ./cmp.nix
    ./rust-tools.nix
    ./trouble.nix
    ./floaterm.nix

    # VSCode(LSP)'s snippet feature in vim.
    ./vsnip.nix

    # Tab, window, and file navigation
    ./navigation.nix

    # Lean & mean status/tabline for vim that's light as air.
    ./airline.nix

    # Syntax highlighting
    ./treesitter.nix
  ];
  config.programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withPython3 = true;
    extraPython3Packages = (ps: with ps; [
      pylint
      pep8
    ]);
    withNodeJs = false;
    plugins = with pkgs.vimPlugins; [
      indentLine # A vim plugin to display the indention levels with thin vertical lines
      neoformat
      vim-better-whitespace # Better whitespace highlighting for Vim
      vim-commentary # Comment stuff out
      vim-eunuch # Helpers for UNIX
      vim-fugitive # A Git wrapper so awesome, it should be illegal
      vim-hoogle # Vim plugin used to query hoogle
      vim-nix # Vim configuration files for Nix
      vim-sensible # Defaults everyone can agree on
      vim-sleuth
      vim-surround # Quoting/parenthesizing made simple
      rust-tools-nvim
    ];
    extraConfig = ''
      " General settings
      syntax on
      set number relativenumber
      set ff=unix
      set tabstop=4
      set shiftwidth=4
      set expandtab
      set cursorline
      set list
      set listchars=tab:>-
      set exrc

      " Whitespace settings
      let g:strip_whitespace_on_save = 1
      let g:strip_whitespace_confirm = 0

      " Code formatting
      augroup fmt
        autocmd!
        autocmd BufWritePre * undojoin | Neoformat
      augroup END

      set swapfile
      set nobackup
      set directory=$XDG_RUNTIME_DIR,~/.vim

      " Allow hiding buffers to not have to save on switching buffers
      set hidden

      " Automatically set the current working directory to the file
      " you're on
      set autochdir
    '';
  };
}
