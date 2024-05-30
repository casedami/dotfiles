return {
  {
    "cdmill/neomodern.nvim",
    config = function()
      require("neomodern").setup({
        toggle_style_key = "<leader>cc",
        code_style = {
          headings = "none",
        },
        ui = {
          plain = true,
          show_eob = false,
          colored_docstrings = false,
          telescope = "borderless",
        },
      })
      require("neomodern").load()
    end,
  },
}
