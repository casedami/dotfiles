return {
  {
    "cdmill/neomodern.nvim",
    priority = 1000,
    config = function()
      require("neomodern").setup({
        theme = "roseprime",
        cycle_theme_key = "<leader>cc",
        cycle_theme_list = { "iceclimber", "coffeecat", "darkforest", "roseprime" },
        toggle_mode_key = "<leader>uc",
        code_style = {
          headings = "italic",
        },
        cursorline_gutter = false,
        transparent = true,
        plain_float = true,
        show_eob = false,
        colored_docstrings = false,
        plugin = {
          lualine = {
            plain = true,
          },
          cmp = {
            plain = true,
          },
          telescope = "bordered",
        },
        highlights = {
          ["LazyNormal"] = { bg = "none" },
          ["CursorLine"] = { bg = "none" },
        },
      })
      require("neomodern").load()
    end,
  },
}
