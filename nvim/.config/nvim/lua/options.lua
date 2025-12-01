local G = vim.g
local L = vim.opt

-- Global opts
G.mapleader = " "
G.maplocalleader = "\\"
G.autoformat = true
G.markdown_recommended_style = 0
G.markdown_folding = 1
G.netrw_banner = 0
G.netrw_browse_split = 0
G.netrw_bufsettings = "noma nomod nu nobl nowrap ro"

-- Local opts
L.autoindent = true
L.autowrite = true
L.background = "dark"
L.clipboard = "unnamedplus"
L.cmdheight = 1
L.colorcolumn = ""
L.completeopt = "menu,menuone,noselect"
L.conceallevel = 2
L.confirm = true
L.cursorline = true
L.cursorlineopt = "number"
L.diffopt = {
    "internal",
    "filler",
    "closeoff",
    "hiddenoff",
    "vertical",
    "algorithm:patience",
    "linematch:60",
    "indent-heuristic",
}
L.expandtab = true
L.fillchars = {
    stl = " ",
    foldopen = "",
    foldclose = "",
    foldsep = " ",
    fold = " ",
    eob = "~",
}
L.foldcolumn = "0"
L.foldmethod = "indent"
L.foldenable = false
L.foldlevel = 5
L.foldnestmax = 10
L.formatoptions = "jcroqlnt"
L.grepformat = "%f:%l:%c:%m"
L.grepprg = "rg --vimgrep"
L.hlsearch = true
L.history = 100
L.ignorecase = true
L.inccommand = "nosplit"
L.jumpoptions = "stack,view"
L.laststatus = 3
L.list = false
L.mousescroll = "ver:3,hor:0"
L.number = true
L.relativenumber = true
L.ruler = false
L.pumblend = 0
L.pumheight = 10
L.sessionoptions = {
    "buffers",
    "curdir",
    "tabpages",
    "winsize",
    "help",
    "globals",
    "skiprtp",
    "folds",
}
L.scrolloff = 10
L.shiftround = true
L.shiftwidth = 4
L.shell = "nu"
L.showbreak = "> "
L.showcmd = false
L.showmode = false
L.showtabline = 0
L.sidescrolloff = 8
L.signcolumn = "yes:1"
L.smartcase = true
L.smartindent = false
L.spelllang = { "en_us" }
L.splitbelow = true
L.splitkeep = "screen"
L.splitright = true
L.statuscolumn = "%s%l  "
L.swapfile = false
L.termguicolors = true
L.tabstop = 4
L.textwidth = 74
L.timeoutlen = 300
L.undofile = true
L.undolevels = 200
L.updatetime = 200
L.virtualedit = "block"
L.wildmode = "longest:full,full"
L.winborder = "rounded"
L.winminwidth = 5
L.wrap = false
