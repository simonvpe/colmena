{ config
, pkgs
, ...
}:
{
  config.programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      lsp-colors-nvim
      nvim-lspconfig
    ];

    # See https://sharksforarms.dev/posts/neovim-rust/
    extraConfig = ''

      nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
      nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
      nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
      nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
      nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
      nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
      nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
      nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
      nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
      nnoremap <silent> <space>rn <cmd>lua vim.lsp.buf.rename()<CR>

      " Code actions
      nnoremap <silent> ga    <cmd>lua vim.lsp.buf.code_action()<CR>

      " Set updatetime for CursorHold
      " 300ms of no cursor movement to trigger CursorHold
      " set updatetime=300
      " Show diagnostic popup on cursor hold
      " autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()

      " Goto previous/next diagnostic warning/error
      nnoremap <silent> g[ <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
      nnoremap <silent> g] <cmd>lua vim.lsp.diagnostic.goto_next()<CR>

      " have a fixed column for the diagnostics to appear in
      " this removes the jitter when warnings/errors flow in
      set signcolumn=yes

      lua<<EOF
      require'lsp-colors'.setup {
        Error = "#db4b4b",
        Warning = "#e0af68",
        Information = "#0db9d7",
        Hint = "#10B981"
      }
      EOF
    '';
  };
}
