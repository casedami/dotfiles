return {
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    event = { "BufRead", "BufNewFile" },
    opts = {
      enable_autocmd = false,
    },
  },
  {
    "echasnovski/mini.comment",
    event = { "BufRead", "BufNewFile" },
    opts = {
      options = {
        custom_commentstring = function()
          return require("ts_context_commentstring.internal").calculate_commentstring()
        end,
      },
    },
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
        FIX = { icon = " ", color = "#ea6962", alt = { "BUG", "ISSUE" } },
        TODO = { icon = "󰦐 ", color = "#7daea3" },
        HACK = { icon = "󰈻 ", color = "#e78a4e" },
        WARN = { icon = "󰹆 ", color = "#d8a657", alt = { "WARNING" } },
        PERF = { icon = " ", color = "#d8a657", alt = { "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = "󰎞 ", color = "#89b472", alt = { "INFO" } },
        TEST = { icon = "󱖫 ", color = "#d3869b", alt = { "TESTING", "PASSED", "FAILED" } },
      },
    },
  },
}
