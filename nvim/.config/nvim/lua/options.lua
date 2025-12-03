-- Global opts
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.autoformat = true
vim.g.markdown_recommended_style = 0
vim.g.markdown_folding = 1
vim.g.netrw_banner = 0
vim.g.netrw_browse_split = 0
vim.g.netrw_bufsettings = "noma nomod nu nobl nowrap ro"

-- Local opts
vim.opt.autoindent = true
vim.opt.autowrite = true
vim.opt.background = "dark"
vim.opt.clipboard = "unnamedplus"
vim.opt.cmdheight = 1
vim.opt.colorcolumn = ""
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.conceallevel = 2
vim.opt.confirm = true
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.opt.diffopt = {
    "internal",
    "filler",
    "closeoff",
    "hiddenoff",
    "vertical",
    "algorithm:patience",
    "linematch:60",
    "indent-heuristic",
}
vim.opt.expandtab = true
vim.opt.fillchars = {
    stl = " ",
    foldopen = "",
    foldclose = "",
    foldsep = " ",
    fold = " ",
    eob = "~",
}
vim.opt.foldcolumn = "0"
vim.opt.foldmethod = "indent"
vim.opt.foldenable = false
vim.opt.foldlevel = 5
vim.opt.foldnestmax = 10
vim.opt.formatoptions = "jcroqlnt"
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --vimgrep"
vim.opt.hlsearch = true
vim.opt.history = 100
vim.opt.iskeyword = "@,48-57,_,192-255,-" -- treat dash as letter in word textobject
vim.opt.ignorecase = true
vim.opt.inccommand = "nosplit"
vim.opt.jumpoptions = "stack,view"
vim.opt.laststatus = 3
vim.opt.list = false
vim.opt.mousescroll = "ver:3,hor:0"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ruler = false
vim.opt.pumblend = 0
vim.opt.pumheight = 10
vim.opt.sessionoptions = {
    "buffers",
    "curdir",
    "tabpages",
    "winsize",
    "help",
    "globals",
    "skiprtp",
    "folds",
}
vim.opt.scrolloff = 10
vim.opt.shiftround = true
vim.opt.shiftwidth = 4
vim.opt.shell = "nu"
vim.opt.showbreak = "> "
vim.opt.showcmd = false
vim.opt.showmode = false
vim.opt.showtabline = 0
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = "yes:1"
vim.opt.smartcase = true
vim.opt.smartindent = false
vim.opt.spelllang = { "en_us" }
vim.opt.splitbelow = true
vim.opt.splitkeep = "screen"
vim.opt.splitright = true
vim.opt.statuscolumn = "%s%l  "
vim.opt.swapfile = false
vim.opt.termguicolors = true
vim.opt.tabstop = 4
vim.opt.textwidth = 74
vim.opt.timeoutlen = 300
vim.opt.undofile = true
vim.opt.undolevels = 200
vim.opt.updatetime = 200
vim.opt.virtualedit = "block"
vim.opt.wildmode = "longest:full,full"
vim.opt.winborder = "rounded"
vim.opt.winminwidth = 5
vim.opt.wrap = false
