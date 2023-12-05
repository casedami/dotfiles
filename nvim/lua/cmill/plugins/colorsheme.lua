return {
  {
    "sainnhe/everforest",
    priority = 1000,
    config = function()
      vim.g.everforest_background = "hard"
      vim.g.everforest_performance = 1
      vim.g.everforest_ui_contrast = "low"
      vim.g.everforest_float_style = "dim"
      vim.g.everforest_cursor = "orange"
      vim.cmd("colorscheme everforest")
      vim.cmd("hi Normal guibg=#161a1c")
      vim.cmd("hi NormalNC guibg=#161a1c")
      vim.cmd("hi CursorLineNr guifg=#E69875")
      vim.cmd("hi MatchParen gui=bold guifg=#E69875 guibg=#161a1c")
      vim.cmd("hi NormalFloat guibg=#0c0e0f")
      vim.cmd("hi TelescopeBorder guifg=#4F5B58")
      vim.cmd("hi ColorColumn guibg=#101314")
      vim.cmd("hi CursorLine guibg=#101314")
      vim.cmd("hi Folded guibg=#101314")
    end,
  },
}
