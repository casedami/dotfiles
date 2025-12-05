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
vim.opt.iskeyword = "@,48-57,_,192-255,-" -- treat dash as letter in word textobject
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
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
vim.opt.splitbelow = true
vim.opt.splitkeep = "screen"
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undolevels = 1000

-- UI
vim.opt.background = "dark"
vim.opt.conceallevel = 2
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.opt.fillchars = "foldsep: ,eob:~"
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
