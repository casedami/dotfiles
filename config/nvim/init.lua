vim.pack.add({
	{ src = "gh:/saghen/blink.cmp", version = vim.version.range("1.*") },
	"gh:/stevearc/conform.nvim",
	"gh:/j-hui/fidget.nvim",
	"gh:/ibhagwan/fzf-lua",
	"gh:/lewis6991/gitsigns.nvim",
	{ src = "file://" .. vim.env.HOME .. "/dev/neomodern.nvim" },
	{ src = "gh:/nvim-treesitter/nvim-treesitter", version = "main" },
	"gh:/nvim-treesitter/nvim-treesitter-textobjects",
	"gh:/casedami/session.nvim",
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
require("options")
require("keymaps")
require("autocmds")
require("lsp")
require("ls")
require("statusline")

-- load plugins
local function import_cfg(dir)
	local files = vim.fn.globpath(string.format("%s/lua/%s", vim.fn.stdpath("config"), dir), "*.lua", false, true)

	for _, f in ipairs(files) do
		require(string.format("%s.%s", dir, vim.fn.fnamemodify(f, ":t:r")))
	end
end
import_cfg("plugin")
require("vim._core.ui2").enable({})

-- load opt-in plugins
vim.cmd("packadd nvim.undotree")
