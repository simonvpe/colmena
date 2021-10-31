{ config
, pkgs
, ...
}:
{
  config.programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      cmp-buffer
      cmp-nvim-lsp
      cmp-path
      cmp-vsnip
      nvim-cmp
    ];

    # See https://sharksforarms.dev/posts/neovim-rust/
    extraConfig = ''
      lua <<EOF
      local cmp = require'cmp'
      cmp.setup {
        -- Enable LSP snippets
        snippet = {
          expand = function(args)
              vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        mapping = {
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-n>'] = cmp.mapping.select_next_item(),
          -- Add tab support
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),
          ['<Tab>'] = cmp.mapping.select_next_item(),
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.close(),
          ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
          })
        },

        -- Installed sources
        sources = {
          { name = 'buffer' },
          { name = 'nvim_lsp' },
          { name = 'path' },
          { name = 'vsnip' },
        },
      }
      EOF
    '';
  };
}
