return {
  {
    "cdmill/neomodern.nvim",
    priority = 1000,
    config = function()
      require("neomodern").setup({
        toggle_style_key = "<leader>uu",
        style = "roseprime",
        code_style = {
          headings = "italic",
        },
        transparent = false,
        plain_float = true,
        show_eob = false,
        colored_docstrings = true,
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
