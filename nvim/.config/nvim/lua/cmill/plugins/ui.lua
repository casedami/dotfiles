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
        opts = {
            culhl = false,
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                local function kmap(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- navigation
                -- stylua: ignore
                kmap("n", "]h", function()
                    if vim.wo.diff then return "[h" end
                    vim.schedule(function() gs.next_hunk() end)
                    return "<Ignore>"
                end, { expr = true })

                -- stylua: ignore
                kmap("n", "[h", function()
                    if vim.wo.diff then return "]h" end
                    vim.schedule(function() gs.prev_hunk() end)
                    return "<Ignore>"
                end, { expr = true })

                -- actions
                -- stylua: ignore start
                kmap("n", "<leader>gs", gs.stage_hunk)
                kmap("v", "<leader>gs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end)
                kmap("n", "<leader>gu", gs.undo_stage_hunk)
                kmap("n", "<leader>gr", gs.reset_hunk)
                kmap("v", "<leader>gr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end)
                kmap("n", "<leader>gS", gs.stage_buffer)
                kmap("n", "<leader>gR", gs.reset_buffer)
                kmap("n", "<leader>gd", gs.diffthis)
                kmap("n", "<leader>gt", gs.toggle_deleted)
                kmap("n", "<leader>gb", function() gs.blame_line({ full = true }) end)
                -- stylua: ignore end
            end,
        },
    },
}
