return {
  {
    "cdmill/neomodern.nvim",
    priority = 1000,
    config = function()
      require("neomodern").setup({
        theme = "darkforest",
        cycle_theme_key = "<leader>cc",
        cycle_theme_list = {
          "iceclimber",
          "coffeecat",
          "darkforest",
          "roseprime",
        },
        toggle_mode_key = "<leader>uc",
        code_style = {
          headings = "italic",
        },
        cursorline_gutter = true,
        transparent = false,
        plain_float = true,
        show_eob = false,
        colored_docstrings = false,
        plugin = {
          lualine = {
            plain = false,
          },
          cmp = {
            plain = true,
          },
          telescope = "bordered",
        },
        highlights = {
          ["LazyNormal"] = { bg = "none" },
          -- ["CursorLine"] = { bg = "none" },
        },
      })
      require("neomodern").load()
    end,
  },
}
