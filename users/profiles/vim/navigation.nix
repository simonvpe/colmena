{ config
, pkgs
, ...
}:

{
  config.programs.neovim.plugins = with pkgs.vimPlugins; [
    hop-nvim
  ];

  config.programs.neovim.extraConfig = ''
    " Automatically set the current working directory to the file
    " you're on
    set autochdir

    " Tabs
    :nnoremap <silent> tn :tabnew<CR>
    :nnoremap <silent> tc :tabclose<CR>
    :nnoremap <silent> th :tabprevious<CR>
    :nnoremap <silent> tl :tabnext<CR>

    " Hop (normal)
    :nnoremap <silent> hl :HopLine<CR>
    :nnoremap <silent> hw :HopWord<CR>

    " Hop (visual) !NOT WORKING
    " :xnoremap <silent> <C-h>l :<C-U>HopLine<CR>
    " :xnoremap <silent> <C-h>w :<C-U>HopWord<CR>

  '';
}
