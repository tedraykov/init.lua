local lsp = require("lsp-zero")
local lspconfig = require('lspconfig')
local util = require('lspconfig.util')
local configs = require('lspconfig.configs')

lsp.preset("recommended")

lsp.ensure_installed({
    'tsserver',
    'rust_analyzer',
    'lua_ls',
    'tailwindcss',
    'eslint'
})

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

-- lsp.configure('tailwindcss', {
--     settings = {
--         tailwindCSS = {
--             classAttributes = { "class", "className", "root" },
--             experimental = {
--                 classRegex = { ":\\s*?[\"'`]([^\"'`]*).*?," }
--             }
--         }
--     }
-- })

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
})

cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

lsp.setup_nvim_cmp({
    mapping = cmp_mappings
})

lsp.set_preferences({
    suggest_lsp_servers = true,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})

lsp.on_attach(function(_, bufnr)
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
    lsp.default_keymaps({buffer = bufnr})
    vim.keymap.set("n", "<leader>ga", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>gr", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>', {buffer = true})
    vim.keymap.set('n', 'gd', '<cmd>Telescope lsp_definitions<cr>', {buffer = true})
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

if not configs.helm_ls then
  configs.helm_ls = {
    default_config = {
      cmd = {"helm_ls", "serve"},
      filetypes = {'helm'},
      root_dir = function(fname)
        return util.root_pattern('Chart.yaml')(fname)
      end,
    },
  }
end

lspconfig.helm_ls.setup {
  filetypes = {"helm"},
  cmd = {"helm_ls", "serve"},
}

vim.diagnostic.config({
    virtual_text = true
})

