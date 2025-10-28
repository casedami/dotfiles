return {
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
                    override_vim_notify = true,
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
        config = function()
            require("gitsigns").setup({
                culhl = false,
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns

                -- stylua: ignore start
                -- navigation
                vim.keymap.set("n", "]h", function() if vim.wo.diff then return "[h" end vim.schedule(function() gs.next_hunk() end) return "<Ignore>" end, { expr = true, desc = "Git: next hunk", buffer = bufnr })
                vim.keymap.set("n", "[h", function() if vim.wo.diff then return "]h" end vim.schedule(function() gs.prev_hunk() end) return "<Ignore>" end, { expr = true, desc = "Git: previous hunk", buffer = bufnr })

                -- actions
                vim.keymap.set("n", "<leader>gs", gs.stage_hunk, { desc = "Git: stage hunk", buffer = bufnr })
                vim.keymap.set("v", "<leader>gs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Git: stage hunk", buffer = bufnr })
                vim.keymap.set("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Git: undo stage", buffer = bufnr })
                vim.keymap.set("n", "<leader>gr", gs.reset_hunk,{ desc = "Git: reset hunk", buffer = bufnr })
                vim.keymap.set("v", "<leader>gr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Git: reset hunk", buffer = bufnr })
                vim.keymap.set("n", "<leader>gS", gs.stage_buffer, { desc = "Git: stage buffer", buffer = bufnr })
                vim.keymap.set("n", "<leader>gR", gs.reset_buffer, { desc = "Git: reset buffer", buffer = bufnr })
                vim.keymap.set("n", "<leader>gd", gs.diffthis, { desc = "Git: diff this", buffer = bufnr })
                vim.keymap.set("n", "<leader>gt", gs.toggle_deleted, { desc = "Git: toggle deleted", buffer = bufnr })
                vim.keymap.set("n", "<leader>gb", function() gs.blame_line({ full = true }) end, { desc = "Git: blame line", buffer = bufnr })
                    -- stylua: ignore end
                end,
            })
        end,
    },
}
