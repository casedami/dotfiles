return {
  {
    "cdmill/neomodern.nvim",
    config = function()
      require("neomodern").setup({
        -- style = "darkforest",
        lualine = {
          transparent = true,
        },
      })
      require("neomodern").load()
    end,
  },
}
