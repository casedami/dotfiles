return {
  {
    "cdmill/neomodern.nvim",
    config = function()
      require("neomodern").setup({
        toggle_style_key = "<leader>cc",
        style = "coffeecat",
        code_style = {
          headings = "none",
        },
        transparent = false,
        ui = {
          lualine = {
            plain = false,
          },
          plain = true,
          show_eob = false,
          colored_docstrings = true,
          telescope = "borderless",
        },
      })
      require("neomodern").load()
    end,
  },
}
