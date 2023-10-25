return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      float_ops = {
        border = "double",
      },
    },
    keys = {
      { "<leader>t", "<cmd>ToggleTerm<cr>", { desc = "Open terminal" } },
    },
  },
}
