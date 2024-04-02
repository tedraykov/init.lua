local lsp = require("lsp-zero")
local lspconfig = require('lspconfig')

lsp.preset("recommended")

-- Fix Undefined global 'vim'
lsp.configure('lua_ls', {
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' }
      }
    }
  }
})

lsp.configure('tailwindcss')

lsp.set_preferences({
  suggest_lsp_servers = true,
  sign_icons = {
    error = 'E',
    warn = 'W',
    hint = 'H',
    info = 'I'
  }
})

lsp.on_attach(function(client, bufnr)
  local opts = { buffer = bufnr, remap = false }
  -- K: Displays hover information about the symbol under the cursor in a floating window.
  -- gd: Jumps to the definition of the symbol under the cursor.
  -- gD: Jumps to the declaration of the symbol under the cursor. Some servers don't implement this feature.
  -- gi: Lists all the implementations for the symbol under the cursor in the quickfix window.
  -- go: Jumps to the definition of the type of the symbol under the cursor.
  -- gr: Lists all the references to the symbol under the cursor in the quickfix window.
  -- gs: Displays signature information about the symbol under the cursor in a floating window.
  -- <F2>: Renames all references to the symbol under the cursor
  -- <F3>: Format code in current buffer.
  -- <F4>: Selects a code action available at the current cursor position.
  -- gl: Show diagnostics in a floating window.
  -- [d: Move to the previous diagnostic in the current buffer.
  -- ]d: Move to the next diagnostic.
  lsp.default_keymaps({ buffer = bufnr })
  vim.keymap.set("n", "<leader>ga", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>gr", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>', { buffer = true })
  vim.keymap.set('n', 'gd', '<cmd>Telescope lsp_definitions<cr>', { buffer = true })

  if client.name == 'null-ls' then
    -- Only format with Black on save
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function()
      vim.lsp.buf.format({ async = true })
    end, { desc = 'Format current buffer with LSP' })
    vim.cmd('autocmd BufWritePre <buffer> Format')
  end
end)

lsp.setup()

lspconfig.eslint.setup({
  on_attach = function(_, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "EslintFixAll",
    })
  end,
})

lspconfig.helm_ls.setup {
  filetypes = { "helm", "yaml" },
  cmd = { "helm_ls", "serve" },
}

vim.diagnostic.config({
  virtual_text = true
})

local null_ls = require('null-ls')
local null_opts = lsp.build_options('null-ls', {})

null_ls.setup({
  on_attach = function(client, bufnr)
    null_opts.on_attach(client, bufnr)
  end,
  sources = {}
})

require("mason").setup()
require("mason-null-ls").setup({
  automatic_installation = false,
})

-- Register Black with null-ls
null_ls.setup({
  sources = {
    null_ls.builtins.formatting.black,
  },
})
