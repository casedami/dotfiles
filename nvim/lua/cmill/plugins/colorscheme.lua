return {
  {
    "cdmill/neomodern.nvim",
    branch = "dev",
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
          telescope = "borderless",
        },
      })
      require("neomodern").load()
    end,
  },
}
