{ config
, pkgs
, ...
}:
{

  config.programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      vim-floaterm
    ];

    extraConfig = ''
      let g:floaterm_keymap_new = '<Up>'
      let g:floaterm_keymap_prev = '<Left>'
      let g:floaterm_keymap_next = '<Right>'
      let g:floaterm_keymap_toggle = '<Down>'
    '';
  };
}
