return {
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    config = function()
      require("kanagawa").setup({
        theme = "wave",
        statementStyle = { bold = false },
        colors = {
          theme = {
            all = {
              ui = {
                bg_gutter = "none",
              },
            },
            wave = {
              ui = {
                bg = "#181616",
                bg_p2 = "#282727",
                bg_p1 = "#282727",
              },
            },
          },
        },
      })
      -- vim.cmd("colorscheme kanagawa")
    end,
  },
  {
    "sainnhe/everforest",
    priority = 1000,
    config = function()
      vim.g.everforest_background = "hard"
      vim.g.everforest_better_performance = 1
      vim.g.everforest_ui_contrast = "high"
      vim.g.everforest_float_style = "dim"
      vim.cmd("colorscheme everforest")
    end,
  },
}
