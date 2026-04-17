-- globals
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

-- netrw
vim.g.netrw_banner = 0
vim.g.netrw_browse_split = 0

-- search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- text
vim.opt.breakindent = true
vim.opt.showbreak = "↳ "
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.textwidth = 79

-- general
vim.opt.clipboard = "unnamedplus"
vim.opt.confirm = true
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undolevels = 1000

-- ui
vim.opt.background = "dark"
vim.opt.conceallevel = 2
vim.opt.cursorlineopt = "both"
vim.opt.laststatus = 3
vim.wo.number = true
vim.opt.pumheight = 10
vim.opt.showtabline = 0
vim.opt.showcmdloc = "statusline"
vim.opt.signcolumn = "yes:1"
vim.opt.statuscolumn = "%s%l  "
vim.opt.ruler = false
vim.opt.winborder = "rounded"
