-- globals
vim.g.proj_dir = vim.env.HOME .. "/dev"
vim.g.icons = {
	diag = {
		gutter = "",
		error = " ",
		hint = "",
		info = "",
		warning = " ",
	},
	diff = {
		add = "┃",
		delete = "_",
		change = "┃",
	},
	location = { "▔", "🮂", "🮃", "🮑", "🮒", "▃", "▂", "▁" },
	lock = "󰍁",
	modified = "*",
	neovim = " ",
	newfile = " ",
	readonly = "󰛐 ",
	unnamed = "",
}

-- leader key
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- netrw
vim.g.netrw_banner = 0
vim.g.netrw_browse_split = 0
vim.g.netrw_bufsettings = "noma nomod nu nobl nowrap ro"

-- search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- text
vim.opt.breakindent = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.textwidth = 79

-- general
vim.opt.clipboard = "unnamedplus"
vim.opt.confirm = true
vim.opt.shell = "nu"
vim.opt.spelllang = { "en_us" }
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undolevels = 1000

-- ui
vim.opt.background = "dark"
vim.opt.conceallevel = 2
vim.opt.laststatus = 3
vim.opt.cursorlineopt = "both"
vim.opt.fillchars = "fold: "
vim.wo.number = true
vim.opt.pumheight = 10
vim.opt.showcmd = false
vim.opt.showtabline = 0
vim.opt.signcolumn = "yes:1"
vim.opt.statuscolumn = "%s%l  "
vim.opt.winborder = "rounded"
