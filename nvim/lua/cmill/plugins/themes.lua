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
    "sainnhe/gruvbox-material",
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_background = "hard"
      vim.g.gruvbox_material_better_performance = 1
      vim.g.gruvbox_material_ui_contrast = "high"
      vim.g.gruvbox_material_float_style = "dim"
      vim.cmd("colorscheme gruvbox-material")
    end,
  },
}
