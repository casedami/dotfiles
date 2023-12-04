return {
  {
    "sainnhe/everforest",
    priority = 1000,
    config = function()
      vim.g.everforest_background = "hard"
      vim.g.everforest_performance = 1
      vim.g.everforest_ui_contrast = "low"
      vim.g.everforest_float_style = "dim"
      vim.cmd("colorscheme everforest")
      vim.cmd("hi Normal guibg=#101314")
      vim.cmd("hi NormalNC guibg=#101314")
      vim.cmd("hi CursorLineNr guifg=#E69875")
      vim.cmd("hi NormalFloat guibg=#0c0e0f")
    end,
  },
}
