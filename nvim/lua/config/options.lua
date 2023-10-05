-- Options are automatically loaded before lazy.nvim startup

-- vim.wo.colorcolumn = "88"
vim.opt.cursorlineopt = "number"
vim.opt.background = "dark"

-- Vimtex options
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
