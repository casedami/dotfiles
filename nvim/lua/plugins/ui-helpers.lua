return {
  {
    "folke/which-key.nvim",
    -- enabled = false,
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 800
    end,
    opts = {
      triggers_blacklist = {
        n = { "v" },
      },
    },
  },
  {
    "folke/todo-comments.nvim",
    opts = {
      keywords = {
        FIX = {
          icon = " ",
          color = "error",
          alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
        },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = "󰈻 ", color = "warning" },
        WARN = { icon = "󱇏 ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = "󰄉 ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = "󰎞 ", color = "hint", alt = { "INFO" } },
        TEST = {
          icon = "󱖫 ",
          color = "test",
          alt = { "TESTING", "PASSED", "FAILED" },
        },
      },
    },
  },
}
