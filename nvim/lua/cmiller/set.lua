
-- line 
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

-- tab and indent
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false
vim.opt.smartindent = true
vim.opt.autoindent = true

vim.opt.backspace = "indent,eol,start"
vim.opt.wrap = false

-- file
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.history = 500
vim.opt.isfname:append("@-@")

-- search/regex
vim.opt.ignorecase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.magic = true
vim.opt.regexpengine = 0

-- visual
vim.opt.termguicolors = true
vim.opt.updatetime = 50

-- theme setup
vim.cmd.colorscheme "catppuccin-mocha"
vim.opt.colorcolumn = "80"

