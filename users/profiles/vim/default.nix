{ config
, pkgs
, ...
}:

{
  config.programs.neovim = {
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
      # rainbow_parentheses # Simpler Rainbow Parentheses
      # ale # replaced by nvim-lspconfig
      indentLine # A vim plugin to display the indention levels with thin vertical lines
      neoformat
      nvim-lspconfig
      semshi # Semantic Highlighting for Python in Neovim
      # skim-vim TODO: not working but should replace fzf
      fzf-vim # replaced by skim-vim
      vim-airline # lean & mean status/tabline for vim that's light as air
      vim-better-whitespace # Better whitespace highlighting for Vim
      vim-commentary # Comment stuff out
      vim-eunuch # Helpers for UNIX
      vim-fugitive # A Git wrapper so awesome, it should be illegal
      vim-hoogle # Vim plugin used to query hoogle
      vim-nix # Vim configuration files for Nix
      vim-sensible # Defaults everyone can agree on
      vim-signify # Show a diff using Vim its sign column
      vim-sleuth
      vim-surround # Quoting/parenthesizing made simple
      wal-vim # Use pywal color theme
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
      set exrc

      " For skim (the skim plugin doesn't work currently, hence fzf is still here)
      " command! -bang -nargs=* Ag call fzf#vim#ag_interactive(<q-args>, fzf#vim#with_preview('right:50%:hidden', 'alt-h'))
      " command! -bang -nargs=* Rg call fzf#vim#rg_interactive(<q-args>, fzf#vim#with_preview('right:50%:hidden', 'alt-h'))

      " Ripgrep and Fzf bindings
      nnoremap <C-b> :Buffers<Cr>
      nnoremap <C-t> :Files<Cr>
      nnoremap <C-h> :Rg<Cr>
      nnoremap <C-l> :BLines<Cr>
      nnoremap <C-L> :Lines<Cr>

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
}
