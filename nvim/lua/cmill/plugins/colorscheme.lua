return {
  {
    "cdmill/neomodern.nvim",
    priority = 1000,
    config = function()
      require("neomodern").setup({
        toggle_style_key = "<leader>cc",
        style = "iceclimber",
        code_style = {
          headings = "italic",
        },
        transparent = true,
        ui = {
          lualine = {
            plain = false,
          },
          cmp = {
            plain = true,
          },
          plain_float = true,
          show_eob = false,
          colored_docstrings = true,
          telescope = "bordered",
        },
        highlights = {
          ["LazyNormal"] = { bg = "none" },
        },
      })
      require("neomodern").load()
    end,
  },
}
