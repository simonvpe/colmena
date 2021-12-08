{ config
, ...
}:

{
  config.programs.neovim.extraConfig = ''
    lua<<EOF
      require'lspconfig'.clangd.setup{}
    EOF
  '';
}
