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
    "cohama/lexima.vim",
    event = "InsertEnter",
    config = function() end,
  },
  {
    "folke/todo-comments.nvim",
    event = { "BufRead", "BufNewFile" },
    -- stylua: ignore
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>xx", "<cmd>TodoTelescope<cr>", desc = "Todo (Trouble)" },
    },
    -- stylua: ignore
    opts = {
      keywords = {
        FIX = { icon = " ", color = "#F85552", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
        TODO = { icon = "󰦐 ", color = "#3a94c5" },
        HACK = { icon = "󰈻 ", color = "#f57d26" },
        WARN = { icon = "󰹆 ", color = "#dfa000", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", color = "#dfa000", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = "󰎞 ", color = "#35A77C", alt = { "INFO" } },
        TEST = { icon = "󱖫 ", color = "#DF69BA", alt = { "TESTING", "PASSED", "FAILED" } },
      },
    },
  },
}
