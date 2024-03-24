return {
  {
    "cdmill/neomodern.nvim",
    config = function()
      require("neomodern").setup({
        -- style = "darkforest",
        plain_ui = true,
      })
      require("neomodern").load()
    end,
  },
}
