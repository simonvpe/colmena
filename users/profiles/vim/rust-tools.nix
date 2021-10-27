{ config
, pkgs
, ...
}:
{
  config.programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      # Extra rust tools for writing applications in neovim using the native lsp.
      # This plugin adds extra functionality over rust analyzer.
      rust-tools-nvim
      # An implementation of the Popup API from vim in Neovim
      popup-nvim
      # All the lua functions I don't want to write twice.
      # plenary-nvim # TODO: debugging
      # nvim-dap # TODO: Debugging
      # Gaze deeply into unknown regions using the power of the moon.
      telescope-nvim
    ];

    # See https://sharksforarms.dev/posts/neovim-rust/
    extraConfig = ''
      set completeopt=menuone,noinsert,noselect
      set shortmess+=c

      lua<<EOF
      local nvim_lsp = require('lspconfig')

      require'rust-tools'.setup {
        tools = {
          autoSetHints = true,
          hover_with_actions = true,
          inlay_hints = {
              show_parameter_hints = false,
              parameter_hints_prefix = "",
              other_hints_prefix = "",
          },
          runnables = {
            use_telescope = true,
          },
          debuggables = {
            use_telescope = true,
          },
        },

        server = {
          settings = {
            ["rust-analyzer"] = {
              checkOnSave = {
                command = "clippy"
              },
            },
          },
        },

        root_dir = function()
          return vim.fn.getcwd()
        end
      }

      require'rust-tools.inlay_hints'.set_inlay_hints()
      EOF
    '';
  };
}
