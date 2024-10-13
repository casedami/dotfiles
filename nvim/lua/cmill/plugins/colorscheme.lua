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

  -- deepblue = {
  --   alt = "#bbbac1",
  --   bg = "#1B1D21", --
  --   border = "#4a4a4f",
  --   builtin = "#7da77e", --
  --   comment = "#555555",
  --   constant = "#8192C7",
  --   dim = "#111111",
  --   fg = "#bbbac1",
  --   float = "#212123",
  --   func = "#4a818c", --
  --   keyword = "#abbceb", --
  --   line = "#1d1d1f",
  --   operator = "#bbbac1", --
  --   preproc = "#9879b0",
  --   property = "#8c8abd", --
  --   string = "#dbbc8a", --
  --   type = "#8192C7", --
  --   visual = "#26262a",
  --   error = "#ba5f60",
  --   hint = "#abbceb",
  --   warning = "#ad9368",
  --   delta = "#8192C7",
  --   plus = "#6b8f89",
  -- },
}
