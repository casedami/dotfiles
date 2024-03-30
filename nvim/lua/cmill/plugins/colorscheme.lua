return {
  {
    "cdmill/neomodern.nvim",
    config = function()
      require("neomodern").setup({
        -- style = "darkforest",
        ui = {
          plain = true,
          -- colored_docstrings = false,
          lualine = {
            bold = false,
          },
        },
      })
      require("neomodern").load()
    end,
  },
}
