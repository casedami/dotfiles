return {
  {
    "stevearc/oil.nvim",
    opts = {},
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>e", "<cmd>Oil<cr>", desc = "Toggle explorer", silent = true },
    },
    cmd = "E",
    config = function()
      require("oil").setup({
        view_options = {
          show_hidden = true,
        },
        preview = {
          border = "shadow",
        },
      })
      vim.api.nvim_create_user_command("E", "Oil", { desc = "Open Explorer" })
    end,
  },
}
