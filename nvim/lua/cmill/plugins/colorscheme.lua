return {
  {
    "cdmill/neomodern.nvim",
    config = function()
      require("neomodern").setup({
        toggle_style_key = "<leader>cc",
        style = "roseprime",
        code_style = {
          headings = "none",
        },
        transparent = false,
        ui = {
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
