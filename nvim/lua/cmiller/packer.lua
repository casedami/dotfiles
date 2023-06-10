-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
      'nvim-telescope/telescope.nvim', tag = '0.1.1',
      -- or                            , branch = '0.1.x',
      requires = { {'nvim-lua/plenary.nvim'} }
  }
  use{ 'catppuccin/nvim', as = "catppuccin" }
  use{'nvim-treesitter/nvim-treesitter', {run= ':TSUpdate'}}
  use{'nvim-tree/nvim-tree.lua'}
  use{'numToStr/Comment.nvim'}
  use{ "jose-elias-alvarez/null-ls.nvim",
	requires = { "nvim-lua/plenary.nvim" },
  }
  use {
      'nvim-lualine/lualine.nvim',
      requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }
  use{'nvim-tree/nvim-web-devicons'}
  use {
	  'VonHeikemen/lsp-zero.nvim',
	  branch = 'v1.x',
	  requires = {
		  -- LSP Support
		  {'williamboman/mason.nvim',								-- Required 
				opts = {
					ensure_installed = {
						"black",
						"pyright",
						"mypy",
						"ruff",
						"debugpy",
						"lua-language-server",
					},
				},
		  },
		  {'williamboman/mason-lspconfig.nvim'},					-- Required
		  {'neovim/nvim-lspconfig'},								-- Required

		  -- Autocompletion
		  {'hrsh7th/nvim-cmp'},										-- Required
		  {'hrsh7th/cmp-nvim-lsp'},									-- Required
		  {'hrsh7th/cmp-buffer'},									-- Required
		  {'hrsh7th/cmp-path'},										-- Required
		  {'saadparwaiz1/cmp_luasnip'},								-- Required
		  {'hrsh7th/cmp-nvim-lua'},									-- Required

		  -- Snippets
		  {'L3MON4D3/LuaSnip'},										-- Required
		  {'rafamadriz/friendly-snippets'},							-- Required
	  }
  }
end)
