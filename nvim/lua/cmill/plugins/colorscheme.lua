return {
  {
    "cdmill/neomodern.nvim",
    config = function()
      require("neomodern").setup({
        -- style = "darkforest",
        plain_ui = true,
        lualine = {
          bold = false,
        },
      })
      require("neomodern").load()
    end,
  },
}
