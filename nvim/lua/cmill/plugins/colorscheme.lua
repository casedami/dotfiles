return {
  {
    "cdmill/neomodern.nvim",
    priority = 1000,
    config = function()
      require("neomodern").setup({
        theme = "darkforest",
        toggle_style_key = "<leader>uu",
        toggle_mode_key = "<leader>uc",
        toggle_style_list = { "iceclimber", "coffeecat", "darkforest", "roseprime" },
        style = "roseprime",
        code_style = {
          headings = "italic",
        },
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
        },
      })
      require("neomodern").load()
    end,
  },
}
