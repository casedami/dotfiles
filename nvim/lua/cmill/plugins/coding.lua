return {
  {
    "folke/todo-comments.nvim",
    event = "BufReadPost",
    -- stylua: ignore
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>xx", "<cmd>TodoTelescope<cr>", desc = "Todo (Trouble)" },
    },
    opts = {
      keywords = {
        FIX = { icon = " ", alt = { "BUG", "ISSUE" } },
        TODO = { icon = " " },
        HACK = { icon = "󰈻 " },
        WARN = { icon = "󰹆 ", alt = { "WARNING" } },
        PERF = { icon = " ", alt = { "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = "󰎞 ", alt = { "INFO", "IDEA" } },
        TEST = { icon = "󱖫 ", alt = { "TESTING", "PASSED", "FAILED" } },
        MARK = { icon = " " },
      },
      highlight = {
        keyword = "",
        after = "",
      },
    },
  },
  {
    "danymat/neogen",
    event = "LspAttach",
    config = function()
      require("neogen").setup({
        snippet_engine = "nvim",
      })
    end,
  },
  {
    "sindrets/diffview.nvim",
    cmd = "DiffviewOpen",
    keys = {
      {
        "<leader>gg",
        "<cmd>DiffviewOpen<cr>",
        desc = "Open diffview",
        silent = true,
      },
      {
        "<leader>gw",
        "<cmd>DiffviewClose<cr>",
        desc = "Close diffview",
        silent = true,
      },
    },
    opts = {
      file_panel = {
        listing_style = "list",
        win_config = {
          position = "bottom",
          height = 10,
        },
      },
    },
  },
}
