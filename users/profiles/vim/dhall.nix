{ config
, pkgs
, ...
}:
{
  config.programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      dhall-vim
    ];
  };
}
