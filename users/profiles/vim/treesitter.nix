{ config
, pkgs
, ...
}:
let
  treesitter = pkgs.vimPlugins.nvim-treesitter.withPlugins (p: with p; [
    tree-sitter-bash
    tree-sitter-c
    tree-sitter-cpp
    tree-sitter-haskell
    tree-sitter-json
    tree-sitter-nix
    tree-sitter-python
    tree-sitter-rust
    tree-sitter-toml
    tree-sitter-yaml
  ]);
in
{
  config.programs.neovim.plugins = [ treesitter ];
  config.programs.neovim.extraConfig = ''
    lua <<EOF
      require'nvim-treesitter.configs'.setup {
        highlight = { enable = true },
        incremental_selection = { enable = true },
        textobjects = { enable = true },
      }
    EOF
  '';

}
