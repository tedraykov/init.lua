return {
  "nvim-tree/nvim-tree.lua",
  config = function()
    -- set termguicolors to enable highlight groups
    vim.opt.termguicolors = true

    local function my_on_attach(bufnr)
      local api = require "nvim-tree.api"

      -- default mappings
      api.config.mappings.default_on_attach(bufnr)

      -- custom mappings
      vim.keymap.set('n', '<leader>t', api.tree.toggle)
    end

    -- OR setup with some options
    require("nvim-tree").setup({
      sort_by = "case_sensitive",
      on_attach = my_on_attach,
      view = {
        width = 40,
      },
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = false,
      },
    })
  end
}
