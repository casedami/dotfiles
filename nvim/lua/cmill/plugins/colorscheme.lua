return {
  {
    "cdmill/neomodern.nvim",
    config = function()
      require("neomodern").setup({
        -- style = "darkforest",
        code_style = {
          headings = "none",
        },
        ui = {
          plain = true,
          show_eob = false,
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
