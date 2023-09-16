-- Options are automatically loaded before lazy.nvim startup

vim.opt.colorcolumn = "88"

-- Vimtex options
vim.opt.wildignore = {
  "*.aux",
  "*.lof",
  "*.lot",
  "*.fls",
  "*.out",
  "*.toc",
  "*.fmt",
  "*.fot",
  "*.cb",
  "*.cb2",
  ".*.lb",
  "__latex*",
  "*.fdb_latexmk",
  "*.synctex",
  "*.synctex(busy)",
  "*.synctex.gz",
  "*.synctex.gz(busy)",
  "*.pdfsync",
  "*.bbl",
  "*.bcf",
  "*.blg",
  "*.run.xml",
  "indent.log",
  "*.pdf",
}
vim.g.tex_flavor = "latex"
vim.g.vimtex_view_method = "skim"
vim.g.vimtex_view_skim_sync = 1
vim.g.vimtex_view_skim_activate = 1
vim.g.vimtex_indent_on = 1
vim.g.vimtex_syntax_conceal_disable = 1
vim.g.vimtex_compiler_latexmk_engines = { ["_"] = "-xelatex" }
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
vim.g.vimtex_quickfix_open_on_warning = 0
