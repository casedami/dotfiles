
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

-- status line
-- vim.opt.cmdheight = 1
-- vim.opt.statusline = " %f %=  %l:%c | %p%% | %Y "
-- vim.opt.showmode = true

-- theme setup
require("github-theme").setup({
  theme_style = "dark_default",
  function_style = "italic",
  sidebars = {"qf", "vista_kind", "terminal", "packer"},

  -- Change the "hint" color to the "orange" color, and make the "error" color 
  -- bright red
  colors = {hint = "orange", error = "#ff0000"},

  -- Overwrite the highlight groups
  overrides = function(c)
    return {
      htmlTag = {fg = c.red, bg = '#282c34', sp = c.hint, style = "underline"},
      DiagnosticHint = {link = "LspDiagnosticsDefaultHint"},
      -- this will remove the highlight groups
      TSField = {},
    }
  end
})

vim.cmd('colorscheme github_dark_default')

-- autocmd needed to change color of colorcolumn on startup
vim.opt.colorcolumn = "80"
vim.cmd([[
    augroup MyColors
    autocmd!
    autocmd ColorScheme * highlight ColorColumn guifg=0 guibg=Black
    augroup end
]])

