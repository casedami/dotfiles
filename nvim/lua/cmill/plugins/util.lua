return {
  {
    "folke/persistence.nvim",
    event = "BufRead",
    opts = {
      options = {
        "buffers",
        "curdir",
        "tabpages",
        "winsize",
        "help",
        "globals",
        "skiprtp",
      },
    },
    -- stylua: ignore
    keys = {
      { "<leader>ss", function() require("persistence").load() end, desc = "Restore Session" },
      { "<leader>sl", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
    },
  },
  {
    "tpope/vim-fugitive",
    event = "BufRead",
    keys = {
      { "<leader>gs", "<cmd>Git status<cr>" },
      { "<leader>gl", "<cmd>Git log1<cr>" },
      { "<leader>gL", "<cmd>Git glog<cr>" },
      { "<leader>gg", ":Git " },
    },
  },
}
