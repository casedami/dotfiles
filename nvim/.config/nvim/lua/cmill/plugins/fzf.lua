return {
    {
        "ibhagwan/fzf-lua",
        lazy = false,
        config = function()
            vim.opt.guicursor:remove({ "t:block-blinkon500-blinkoff500-TermCursor" })
            require("fzf-lua").setup({
                winopts = {
                    backdrop = 100,
                    height = 0.6,
                    width = 0.8,
                    row = 0.5,
                    col = 0.5,
                },
                oldfiles = {
                    cwd_only = true,
                },
            })

            require("fzf-lua").register_ui_select()

            -- stylua: ignore start
            vim.keymap.set("n", "<leader>F", "<cmd>FzfLua global<cr>", { desc = "Finder: global", silent = true })
            vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua files<cr>", { desc = "Finder: files", silent = true })
            vim.keymap.set("n", "<leader>fr", "<cmd>FzfLua oldfiles<cr>", { desc = "Finder: recent files", silent = true })
            vim.keymap.set("n", "<leader>f,", "<cmd>FzfLua buffers<cr>", { desc = "Finder: open buffers", silent = true })
            vim.keymap.set("n", "<leader>fR", "<cmd>FzfLua resume<cr>", { desc = "Finder: resume", silent = true })

            vim.keymap.set("n", "<leader>fg", "<cmd>FzfLua live_grep<cr>", { desc = "Finder: grep", silent = true })
            vim.keymap.set("n", "<leader>fG", "<cmd>FzfLua grep_cword<cr>", { desc = "Finder: grep word under cursor", silent = true })

            vim.keymap.set("n", "<leader>G", "<cmd>FzfLua git_status<cr>", { desc = "Git: status", silent = true })
            vim.keymap.set("n", "<leader>GL", "<cmd>FzfLua git_commits<cr>", { desc = "Git: log", silent = true })
            vim.keymap.set("n", "<leader>GD", "<cmd>FzfLua git_diff<cr>", { desc = "Git: diff", silent = true })

            vim.keymap.set("n", "gd", "<cmd>FzfLua lsp_definitions<cr>", { desc = "LSP: definitions", silent = true })
            vim.keymap.set("n", "<leader>lr", "<cmd>FzfLua lsp_references<cr>", { desc = "LSP: search references", silent = true })
            vim.keymap.set("n", "<leader>ls", "<cmd>FzfLua lsp_live_workspace_symbols<cr>", { desc = "LSP: search workspace symbols", silent = true })
            vim.keymap.set("n", "<leader>li", "<cmd>FzfLua lsp_incoming_calls<cr>", { desc = "LSP: search incoming calls", silent = true })
            vim.keymap.set("n", "<leader>lo", "<cmd>FzfLua lsp_outgoing_calls<cr>", { desc = "LSP: search outgoing calls", silent = true })
            vim.keymap.set("n", "<leader>ld", "<cmd>FzfLua diagnostics_workspace<cr>", { desc = "LSP: search workspace diagnostics", silent = true })

            vim.keymap.set("n", "<leader>fh", "<cmd>FzfLua helptags<cr>", { desc = "Finder: help", silent = true })
            vim.keymap.set("n", "<leader>fH", "<cmd>FzfLua highlights<cr>", { desc = "Finder: highlights", silent = true })
            vim.keymap.set("n", "<leader>fm", "<cmd>FzfLua marks<cr>", { desc = "Finder: marks", silent = true })
            vim.keymap.set("n", "<leader>f:", "<cmd>FzfLua command_history<cr>", { desc = "Finder: command history", silent = true })
            vim.keymap.set("n", "<leader>f/", "<cmd>FzfLua search_history<cr>", { desc = "Finder: search history", silent = true })
            -- stylua: ignore end
        end,
    },
}
