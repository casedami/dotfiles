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
        FIX = { icon = " ", color = "#ea6962", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
        TODO = { icon = "󰦐 ", color = "#7daea3" },
        HACK = { icon = "󰈻 ", color = "#e78a4e" },
        WARN = { icon = "󰹆 ", color = "#d8a657", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", color = "#d8a657", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = "󰎞 ", color = "#89b472", alt = { "INFO" } },
        TEST = { icon = "󱖫 ", color = "#d3869b", alt = { "TESTING", "PASSED", "FAILED" } },
      },
    },
  },
}
