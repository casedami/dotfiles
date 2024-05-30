return {
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
        TODO = { icon = " " },
        HACK = { icon = "󰈻 " },
        WARN = { icon = "󰹆 ", alt = { "WARNING" } },
        PERF = { icon = " ", alt = { "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = "󰎞 ", alt = { "INFO", "IDEA" } },
        TEST = { icon = "󱖫 ", alt = { "TESTING", "PASSED", "FAILED" } },
        MARK = { icon = " " },
      },
    },
  },
  {
    "tpope/vim-fugitive",
    dependencies = {
      "sindrets/diffview.nvim",
    },
  },
  {
    "Shatur/neovim-session-manager",
    config = function()
      require("session_manager").setup({
        autoload_mode = "disabled",
        autoload_last_session = false,
        autosave_last_session = false,
      })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufRead", "BufNewFile" },
    config = function()
      -- stylua: ignore
      require("gitsigns").setup({
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- navigation
          map("n", "]h", function()
            if vim.wo.diff then return "[h" end
            vim.schedule(function() gs.next_hunk() end)
            return "<Ignore>"
          end, { expr = true })

          map("n", "[h", function()
            if vim.wo.diff then return "]h" end
            vim.schedule(function() gs.prev_hunk() end)
            return "<Ignore>"
          end, { expr = true })

          -- actions
          map("n", "<localleader>gs", gs.stage_hunk)
          map("v", "<localleader>gs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end)
          map("n", "<localleader>gu", gs.undo_stage_hunk)
          map("n", "<localleader>gr", gs.reset_hunk)
          map("v", "<localleader>gr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end)
          map("n", "<localleader>gS", gs.stage_buffer)
          map("n", "<localleader>gR", gs.reset_buffer)
          map("n", "<localleader>gd", gs.diffthis)
          map("n", "<localleader>gtd", gs.toggle_deleted)
          map("n", "<localleader>gb", function() gs.blame_line({ full = true }) end)
        end,
      })
    end,
  },
}
