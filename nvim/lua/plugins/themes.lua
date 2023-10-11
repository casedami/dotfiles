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
