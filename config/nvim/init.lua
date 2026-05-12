vim.g.icons = {
	diag = {
		gutter = "",
		error = " ",
		other = " ",
	},
	lock = "󰍁",
	modified = "*",
	neovim = " ",
	newfile = " ",
	readonly = "󰛐 ",
	unnamed = "",
}

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.pack.add({
	{ src = "gh:/saghen/blink.cmp", version = vim.version.range("1.*") },
	"gh:/stevearc/conform.nvim",
	"gh:/j-hui/fidget.nvim",
	"gh:/ibhagwan/fzf-lua",
	"gh:/lewis6991/gitsigns.nvim",
	{ src = "file://" .. vim.env.HOME .. "/dev/neomodern.nvim", version = "improve-base16-palette" },
	{ src = "gh:/nvim-treesitter/nvim-treesitter", version = "main" },
	"gh:/nvim-treesitter/nvim-treesitter-textobjects",
	"gh:/nvim-treesitter/nvim-treesitter-context",
	"gh:/chomosuke/typst-preview.nvim",
})

-- load colorscheme first
require("neomodern").setup({
	theme = "hojicha",
	gutter = {
		cursorline = true,
	},
})
require("neomodern").load()

-- load main config
require("cdm.statusline")
require("cdm.ls")
require("cdm.session")
require("cdm.lsp")

-- load plugins
local function import_cfg(dir)
	local files = vim.fn.globpath(string.format("%s/lua/cdm/%s", vim.fn.stdpath("config"), dir), "*.lua", false, true)

	for _, f in ipairs(files) do
		require(string.format("cdm.%s.%s", dir, vim.fn.fnamemodify(f, ":t:r")))
	end
end
import_cfg("plugins")
require("vim._core.ui2").enable({})

-- load opt-in plugins
vim.cmd("packadd nvim.undotree")
