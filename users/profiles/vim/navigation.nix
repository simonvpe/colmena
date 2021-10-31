{ config
, ...
}:

{
  config.programs.neovim.extraConfig = ''
    " Automatically set the current working directory to the file
    " you're on
    set autochdir

    " Tabs
    :nnoremap <silent> tn :tabnew<CR>
    :nnoremap <silent> tc :tabclose<CR>
    :nnoremap <silent> th :tabprevious<CR>
    :nnoremap <silent> tl :tabnext<CR>
  '';
}
