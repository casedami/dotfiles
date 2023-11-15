return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    config = function()
      require("catppuccin").setup({
        flavour = "frappe",
        color_overrides = {
          all = {
            base = "#000000",
          },
        },
      })
      -- vim.cmd("colorscheme catppuccin")
    end,
  },
  {
    "sainnhe/gruvbox-material",
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_background = "hard"
      vim.g.gruvbox_material_performance = 1
      vim.g.gruvbox_material_ui_contrast = "high"
      vim.g.gruvbox_material_float_style = "dim"
      vim.g.gruvbox_material_show_end_of_buffer = 1
      vim.cmd("colorscheme gruvbox-material")
    end,
  },
}
