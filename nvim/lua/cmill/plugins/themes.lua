return {
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    opts = function()
      require("kanagawa").setup({
        colors = {
          theme = {
            all = {
              ui = {
                bg_gutter = "none",
              },
            },
          },
        },
        transparent = false,
      })
    end,
  },
  {
    "neanias/everforest-nvim",
    priority = 1000,
    config = function()
      require("everforest").setup({
        background = "hard",
        ui_contrast = "high",
      })
      vim.cmd([[colorscheme everforest]])
    end,
  },
  -- {
  --   "EdenEast/nightfox.nvim",
  --   lazy = false,
  --   opts = function()
  --     require("nightfox").setup({
  --       options = {
  --         transparent = false,
  --       },
  --     })
  --   end,
  -- },
}
