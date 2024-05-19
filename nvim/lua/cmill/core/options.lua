local global_opts = {
  -- LEADER KEYS
  mapleader = " ",
  maplocalleader = "\\",

  -- NETRW
  -- netrw_banner = 0,
  -- netrw_browse_split = 0,
  -- netrw_bufsettings = "noma nomod nu nobl nowrap ro",

  -- MARKDOWN
  autoformat = true,
  markdown_recommended_style = 0,
  markdown_folding = 1,

  -- TEX
  tex_flavor = "latex",
  vimtex_view_method = "sioyek",
  vimtex_view_sioyek_options = "--reuse-window",
  vimtex_indent_on = 1,
  vimtex_fold_enabled = 1,
  vimtex_complete_bib = {
    abbr_fmt = "[@type] @author_short (@year)",
    menu_fmt = "@title",
  },
  vimtex_quickfix_open_on_warning = 0,
  vimtex_toc_config = {
    name = "ToC",
    layers = { "content", "todo", "include" },
    show_help = false,
  },
  vimtex_compiler_latexmk_engines = { ["_"] = "-lualatex" },
  vimtex_compiler_method = "latexmk",
  vimtex_compiler_latexmk = {
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
  },
}

local opts = {
  -- TEXT
  fillchars = {
    foldopen = "",
    foldclose = "",
    foldsep = " ",
    fold = " ",
    diff = "╱",
    eob = "~",
  },
  list = true, -- show some invisible characters (tabs...
  scrolloff = 4, -- lines of context
  shiftround = true,
  shiftwidth = 2, -- size of an indent
  spelllang = { "en" },
  tabstop = 2, -- number of spaces tabs count for
  wrap = false,

  -- UX
  autoindent = true,
  autowrite = true,
  clipboard = "unnamedplus", -- sync with system clipboard
  completeopt = "menu,menuone,noselect",
  confirm = true, -- confirm to save changes before exiting modified buffer
  expandtab = true, -- use spaces instead of tabs
  foldmethod = "indent",
  foldenable = false,
  foldlevel = 99,
  history = 100,
  ignorecase = true,
  inccommand = "nosplit", -- preview incremental substitute
  smartcase = true,
  smartindent = false,
  splitbelow = true, -- put new windows below current
  splitkeep = "screen",
  splitright = true, -- put new windows right of current
  timeoutlen = 300,
  undofile = true,
  undolevels = 200,
  virtualedit = "block", -- allow cursor to move where there is no text in visual block mode
  wildmode = "longest:full,full", -- command-line completion mode

  -- UI
  background = "dark",
  colorcolumn = "",
  conceallevel = 2, -- hide * markup for bold and italic
  cursorline = true,
  cursorlineopt = "number",
  foldcolumn = "1", -- always show fold column
  hlsearch = false, -- dont highlighting search matches
  laststatus = 3, -- global statusline
  number = true,
  relativenumber = true,
  pumblend = 1, -- popup blend
  pumheight = 10, -- maximum number of entries in a popup
  ruler = false,
  showcmd = false,
  showmode = false,
  showtabline = 0,
  sidescrolloff = 8, -- columns of context
  signcolumn = "yes:1", -- always show the signcolumn
  statuscolumn = "%!v:lua.require'cmill.core.util'.statuscolumn()",
  termguicolors = true,
  updatetime = 200,
  winminwidth = 5,

  -- MISC
  formatoptions = "jcroqlnt",
  grepformat = "%f:%l:%c:%m",
  grepprg = "rg --vimgrep",
  sessionoptions = {
    "buffers",
    "curdir",
    "tabpages",
    "winsize",
    "help",
    "globals",
    "skiprtp",
    "folds",
  },
}

for k, v in pairs(global_opts) do
  vim.g[k] = v
end

for k, v in pairs(opts) do
  vim.opt[k] = v
end
