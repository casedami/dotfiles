return {
  {
    "numToStr/Comment.nvim",
    event = { "BufRead", "BufNewFile" },
    config = function()
      require("Comment").setup()
    end,
  },
  {
    "tpope/vim-surround",
    event = { "BufRead", "BufNewFile" },
  },
  -- stylua: ignore
  {
    "folke/todo-comments.nvim",
    event = { "BufRead", "BufNewFile" },
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>xx", "<cmd>TodoTelescope<cr>", desc = "Todo (Trouble)" },
    },
    opts = {
      keywords = {
        FIX = { icon = " ", color = "#F85552", alt = { "BUG", "ISSUE" } },
        TODO = { icon = "󰦐 ", color = "#3a94c5" },
        HACK = { icon = "󰈻 ", color = "#f57d26" },
        WARN = { icon = "󰹆 ", color = "#dfa000", alt = { "WARNING" } },
        PERF = { icon = " ", color = "#dfa000", alt = { "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = "󰎞 ", color = "#35A77C", alt = { "INFO" } },
        TEST = { icon = "󱖫 ", color = "#DF69BA", alt = { "TESTING", "PASSED", "FAILED" } },
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufRead", "BufNewFile" },
    config = function()
      require("gitsigns").setup()
    end,
  },
}
