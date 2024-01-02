return {
  {
    "numToStr/Comment.nvim",
    event = { "BufRead", "BufNewFile" },
    config = function()
      require("Comment").setup()
    end,
  },
  -- stylua: ignore
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
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
          map("n", "[h", function()
            if vim.wo.diff then return "[h" end
            vim.schedule(function() gs.next_hunk() end)
            return "<Ignore>"
          end, { expr = true })

          map("n", "]h", function()
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
          map("n", "<localleader>td", gs.toggle_deleted)
          map("n", "<localleader>gb", function() gs.blame_line({ full = true }) end)
        end,
      })
    end,
  },
}
