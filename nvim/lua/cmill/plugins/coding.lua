return {
  {
    "stevearc/overseer.nvim",
    cmd = {
      "OverseerRun",
      "OverseerToggle",
      "OverseerSaveBundle",
      "OverseerLoadBundle",
      "OverseerTaskAction",
    },
    config = function()
      require("overseer").setup({
        form = {
          max_width = 0.3,
        },
        confirm = {
          max_width = 0.3,
        },
      })
      vim.keymap.set("ca", "run", "OverseerRun", { silent = true })
      vim.keymap.set("ca", "res", "OverseerToggle! right", { silent = true })
      vim.keymap.set("ca", "srun", "OverseerSaveBundle", { silent = true })
      vim.keymap.set("ca", "lrun", "OverseerLoadBundle!", { silent = true })
      vim.keymap.set("ca", "runt", "OverseerTaskAction", { silent = true })
    end,
  },
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
        function()
          vim.cmd("DiffviewOpen")
          vim.cmd("vsplit")
          vim.cmd("terminal")
          vim.cmd("wincmd h")
        end,
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
  {
    "Shatur/neovim-session-manager",
    cmd = "SessionManager",
    config = function()
      local config = require("session_manager.config")
      require("session_manager").setup({
        autoload_mode = config.AutoloadMode.Disabled,
        autoload_last_session = false,
        autosave_last_session = false,
      })
    end,
  },
}
