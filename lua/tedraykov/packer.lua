-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd.packadd('packer.nvim')

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.2',
    -- or                            , branch = '0.1.x',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }

  use 'folke/trouble.nvim'
  use({ 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' })
  use {
    "kkoomen/vim-doge",
    run = ":call doge#install()",
    config = function()
      vim.g.doge_comment_jump_modes = { "n", "s" }
    end,
    disable = false,
  }
  use('nvim-treesitter/playground')
  use('theprimeagen/harpoon')
  use('mbbill/undotree')
  use('airblade/vim-gitgutter')
  use('tpope/vim-fugitive')
  use("nvim-treesitter/nvim-treesitter-context");
  use("nvim-tree/nvim-tree.lua")
  use("nvim-tree/nvim-web-devicons")
  use {
    'VonHeikemen/lsp-zero.nvim',
    requires = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' },
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'saadparwaiz1/cmp_luasnip' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-nvim-lua' },

      -- Snippets
      { 'L3MON4D3/LuaSnip' },
      { 'rafamadriz/friendly-snippets' },
    }
  }

  use {
    's1n7ax/nvim-terminal',
    config = function()
      vim.o.hidden = true
      require('nvim-terminal').setup()
    end,
  }
  use("folke/zen-mode.nvim")
  use("github/copilot.vim")

  use 'navarasu/onedark.nvim'
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }
  use 'fatih/vim-go'
  use {
    'numToStr/Comment.nvim',
    pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
  }
  use 'JoosepAlviste/nvim-ts-context-commentstring'
  use 'm4xshen/autoclose.nvim'
  use 'norcalli/nvim-colorizer.lua'

  use({
    "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
    setup = function() vim.g.mkdp_filetypes = { "markdown" } end,
    ft = { "markdown" },
  })
end)
