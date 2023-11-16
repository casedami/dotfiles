return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    -- lazy = true,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        color_overrides = {
          mocha = {
            base = "#000000",
          },
        },
        highlight_overrides = {
          mocha = function(mocha)
            return {
              CursorLine = { bg = "#181825" },
              Folded = { bg = "#181825", fg = "#585b70" },
              ColorColumn = { bg = "#181825" },
              CursorLineNr = { fg = "#ef9f76" },
              FloatBorder = { fg = "#585b70" },
              Visual = { bg = "#313244" },
            }
          end,
        },
        show_end_of_buffer = true,
      })
      vim.cmd("colorscheme catppuccin")
    end,
  },
  {
    "sainnhe/gruvbox-material",
    -- priority = 1000,
    lazy = true,
    config = function()
      vim.g.gruvbox_material_background = "hard"
      vim.g.gruvbox_material_performance = 1
      vim.g.gruvbox_material_ui_contrast = "high"
      vim.g.gruvbox_material_float_style = "dim"
      vim.g.gruvbox_material_show_end_of_buffer = 1
      -- vim.cmd("colorscheme gruvbox-material")
    end,
  },
}
