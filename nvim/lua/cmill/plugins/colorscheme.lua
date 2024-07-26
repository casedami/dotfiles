return {
  {
    "cdmill/neomodern.nvim",
    config = function()
      require("neomodern").setup({
        toggle_style_key = "<leader>cc",
        style = "iceclimber",
        code_style = {
          headings = "italic",
        },
        transparent = false,
        ui = {
          lualine = {
            plain = false,
          },
          cmp = {
            plain = true,
          },
          plain_search = true,
          plain_float = true,
          show_eob = false,
          colored_docstrings = true,
          telescope = "bordered",
        },
      })
      require("neomodern").load()
    end,
  },
}
