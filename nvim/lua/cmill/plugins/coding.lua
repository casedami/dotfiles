return {
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    opts = {
      modes = { insert = true, command = true, terminal = false },
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      skip_ts = { "string" },
      skip_unbalanced = true,
      markdown = true,
    },
  },
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    -- stylua: ignore
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>xx", "<cmd>TodoTelescope<cr>", desc = "Todo (Trouble)" },
    },
    opts = {
      keywords = {
        FIX = { icon = " ", alt = { "BUG", "ISSUE" } },
        TODO = { icon = " " },
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
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
    },
    cmd = "Neogit",
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>" },
      { "<leader>gv", "<cmd>Neogit kind=auto<cr>" },
    },
    config = true,
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
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufRead", "BufNewFile" },
    opts = {
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- navigation
        -- stylua: ignore
        map("n", "]h", function()
          if vim.wo.diff then return "[h" end
          vim.schedule(function() gs.next_hunk() end)
          return "<Ignore>"
        end, { expr = true })

        -- stylua: ignore
        map("n", "[h", function()
          if vim.wo.diff then return "]h" end
          vim.schedule(function() gs.prev_hunk() end)
          return "<Ignore>"
        end, { expr = true })

        -- actions
        -- stylua: ignore start
        map("n", "<leader>gss", gs.stage_hunk)
        map("v", "<leader>gss", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end)
        map("n", "<leader>gu", gs.undo_stage_hunk)
        map("n", "<leader>gr", gs.reset_hunk)
        map("v", "<leader>gr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end)
        map("n", "<leader>gS", gs.stage_buffer)
        map("n", "<leader>gR", gs.reset_buffer)
        map("n", "<leader>gd", gs.diffthis)
        map("n", "<leader>gt", gs.toggle_deleted)
        map("n", "<leader>gb", function() gs.blame_line({ full = true }) end)
        -- stylua: ignore end
      end,
    },
  },
}
