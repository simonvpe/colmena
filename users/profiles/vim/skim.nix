{ config
, pkgs
, ...
}:
{

  config.programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      fzf-vim
      # skim-vim # skim-vim not working properly
    ];

    extraPackages = [
      pkgs.skim
    ];

    extraConfig = ''
      " command! -bang -nargs=* Rg call fzf#vim#rg_interactive(<q-args>, fzf#vim#with_preview('right:50%:hidden', 'alt-h'))

      " Ripgrep and Fzf bindings
      nnoremap <C-b> :Buffers<Cr>
      nnoremap <C-t> :Files<Cr>
      nnoremap <C-h> :Rg<Cr>
      nnoremap <C-l> :BLines<Cr>
      nnoremap <C-L> :Lines<Cr>
    '';
  };
}
