-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Netrw
vim.g.netrw_banner = 0

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Text
vim.opt.breakindent = true
vim.opt.expandtab = true
vim.opt.iskeyword = "@,48-57,_,192-255,-" -- treat dash as letter in word textobject
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.textwidth = 79

-- General
vim.opt.clipboard = "unnamedplus"
vim.opt.confirm = true
vim.opt.shell = "nu"
vim.opt.spelllang = { "en_us" }
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.undofile = true

-- UI
vim.opt.background = "dark"
vim.opt.conceallevel = 2
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.opt.laststatus = 3
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.pumheight = 10
vim.opt.showcmdloc = "statusline"
vim.opt.showmode = false
vim.opt.showtabline = 0
vim.opt.signcolumn = "yes:1"
vim.opt.statuscolumn = "%s%l  "
vim.opt.winborder = "rounded"
