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
      })
    end,
  },
  -- {
  --   "EdenEast/nightfox.nvim",
  --   lazy = true,
  --   opts = function()
  --     require("nightfox").setup({
  --       options = {
  --         transparent = false,
  --       },
  --     })
  --   end,
  -- },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa-wave",
    },
  },
}
