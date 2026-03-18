-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Netrw
vim.g.netrw_banner = 0
vim.g.netrw_browse_split = 0
vim.g.netrw_bufsettings = "noma nomod nu nobl nowrap ro"

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Text
vim.opt.breakindent = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.textwidth = 79

-- General
vim.opt.clipboard = "unnamedplus"
vim.opt.confirm = true
vim.opt.foldenable = false
vim.opt.foldmethod = "indent"
vim.opt.history = 1000
vim.opt.jumpoptions = "stack,view"
vim.opt.sessionoptions = {
	"buffers",
	"curdir",
	"folds",
	"globals",
	"tabpages",
	"winsize",
	"skiprtp",
}
vim.opt.scrolloff = 10
vim.opt.shell = "nu"
vim.opt.spelllang = { "en_us" }
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undolevels = 1000

-- UI
vim.opt.background = "dark"
vim.opt.conceallevel = 2
vim.opt.laststatus = 3
vim.opt.cursorlineopt = "both"
vim.opt.fillchars = "fold: "
vim.wo.number = true
vim.opt.pumheight = 10
vim.opt.showcmdloc = "statusline"
vim.opt.showtabline = 0
vim.opt.signcolumn = "yes:1"
vim.opt.statuscolumn = "%s%l  "
vim.opt.winborder = "rounded"
