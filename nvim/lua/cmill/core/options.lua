vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.g.autoformat = true

local opt = vim.opt

opt.autowrite = true -- enable auto write
opt.background = "dark"
opt.clipboard = "unnamedplus" -- sync with system clipboard
opt.colorcolumn = ""
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 2 -- hide * markup for bold and italic
opt.confirm = true -- confirm to save changes before exiting modified buffer
opt.cursorline = true -- enable highlighting of the current line
opt.cursorlineopt = "number"
opt.expandtab = true -- use spaces instead of tabs
opt.formatoptions = "jcroqlnt" -- tcqj
opt.foldcolumn = "auto"
opt.foldmethod = "indent"
opt.foldenable = false
opt.foldlevel = 99
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true -- ignore case
opt.inccommand = "nosplit" -- preview incremental substitute
opt.laststatus = 3 -- global statusline
opt.list = true -- show some invisible characters (tabs...
opt.number = true -- show current line number
opt.pumblend = 10 -- popup blend
opt.pumheight = 10 -- maximum number of entries in a popup
-- opt.relativenumber = true -- relative line numbers
opt.ruler = false
opt.scrolloff = 4 -- lines of context
opt.sessionoptions =
  { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shiftround = true -- round indent
opt.shiftwidth = 2 -- size of an indent
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.showmode = false -- dont show mode since we have a statusline
opt.showtabline = 0
opt.sidescrolloff = 8 -- columns of context
opt.signcolumn = "yes:1" -- always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- don't ignore case with capitals
opt.smartindent = true -- insert indents automatically
opt.spelllang = { "en" }
opt.splitbelow = true -- put new windows below current
opt.splitkeep = "screen"
opt.splitright = true -- put new windows right of current
opt.statuscolumn = "%!v:lua.require'cmill.core.util'.statuscolumn()"
opt.tabstop = 2 -- number of spaces tabs count for
opt.termguicolors = true -- true color support
opt.timeoutlen = 300
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200 -- save swap file and trigger cursorhold
opt.virtualedit = "block" -- allow cursor to move where there is no text in visual block mode
opt.wildmode = "longest:full,full" -- command-line completion mode
opt.winminwidth = 5 -- minimum window width
opt.wrap = false -- disable line wrap
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  foldsep = " ",
  fold = " ",
  diff = "╱",
  eob = " ",
}

-- fix markdown indentation settings
vim.g.markdown_recommended_style = 0
vim.g.markdown_folding = 1

-- vimtex options
vim.g.tex_flavor = "latex"
vim.g.vimtex_view_method = "skim"
vim.g.vimtex_view_skim_sync = 1
vim.g.vimtex_view_skim_activate = 1
vim.g.vimtex_indent_on = 1
vim.g.vimtex_syntax_conceal_disable = 1
vim.g.vimtex_quickfix_open_on_warning = 0
vim.g.vimtex_compiler_latexmk_engines = { ["_"] = "-lualatex" }
vim.g.vimtex_compiler_method = "latexmk"
vim.g.vimtex_compiler_latexmk = {
  callback = 1,
  continuous = 1,
  executable = "latexmk",
  options = {
    "-shell-escape",
    "-verbose",
    "-file-line-error",
    "-synctex=1",
    "-interaction=nonstopmode",
  },
}
