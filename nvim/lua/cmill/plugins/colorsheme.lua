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
    end,
  },
}
