return {
    {
        "cdmill/focus.nvim",
        cmd = { "Focus", "Zen", "Narrow" },
        opts = {
            window = {
                width = 100,
            },
        },
    },
    { "echasnovski/mini.icons", version = "*" },
    {
        "j-hui/fidget.nvim",
        event = "BufReadPost",
        config = function()
            require("fidget").setup({
                -- logger = {
                --     level = vim.log.levels.INFO,
                -- },
                notification = {
                    window = {
                        winblend = 0,
                    },
                },
            })
            local banned_messages = { "No information available" }
            vim.notify = function(msg, ...)
                for _, banned in ipairs(banned_messages) do
                    if msg == banned then
                        return
                    end
                end
                return require("fidget").notify(msg, ...)
            end
        end,
    },
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufRead", "BufNewFile" },
        opts = {
            culhl = true,
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
