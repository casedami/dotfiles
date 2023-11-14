return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
  },
  {
    "cdmill/gruvbox-material",
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_background = "hard"
      vim.g.gruvbox_material_performance = 1
      vim.g.gruvbox_material_ui_contrast = "high"
      vim.g.gruvbox_material_float_style = "dim"
      vim.cmd("colorscheme gruvbox-material")
    end,
  },
}
