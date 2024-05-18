return {
  {
    "cdmill/neomodern.nvim",
    config = function()
      require("neomodern").setup({
        style = "iceclimber",
        toggle_style_key = "<leader>cc",
        code_style = {
          headings = "none",
        },
        ui = {
          plain = true,
          show_eob = false,
          -- colored_docstrings = false,
        },
      })
      require("neomodern").load()
    end,
  },
}
