return {
    {
        "ibhagwan/fzf-lua",
        lazy = false,
        -- stylua: ignore
        keys = {
            { "<leader>F", "<cmd>FzfLua global<cr>", desc = "search" },
            { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "search files" },
            { "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "search recent files", },
            { "<leader>f,", "<cmd>FzfLua buffers<cr>", desc = "search open buffers", },
            { "<leader>fR", "<cmd>FzfLua resume<cr>", desc = "search resume" },

            { "<leader>fg", "<cmd>FzfLua live_grep<cr>", desc = "search grep" },
            { "<leader>fG", "<cmd>FzfLua grep_cWORD<cr>", desc = "search grep word under cursor" },

            { "<leader>G", "<cmd>FzfLua git_status<cr>", desc = "search git status" },
            { "<leader>GL", "<cmd>FzfLua git_commits<cr>", desc = "search git log" },
            { "<leader>GD", "<cmd>FzfLua git_diff<cr>", desc = "open git diff" },

            { "gd", "<cmd>FzfLua lsp_definitions<cr>", desc = "search lsp definitions" },
            { "<leader>lr", "<cmd>FzfLua lsp_references<cr>", desc = "search lsp references" },
            { "<leader>ls", "<cmd>FzfLua lsp_live_workspace_symbols<cr>", desc = "search lsp workspace symbols" },
            { "<leader>li", "<cmd>FzfLua lsp_incoming_calls<cr>", desc = "search lsp incoming calls" },
            { "<leader>lo", "<cmd>FzfLua lsp_outgoing_calls<cr>", desc = "search lsp outgoing calls" },
            { "<leader>ld", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "search workspace diagnostics" },

            { "<leader>fh", "<cmd>FzfLua helptags<cr>", desc = "search help" },
            { "<leader>fH", "<cmd>FzfLua highlights<cr>", desc = "search highlights" },
            { "<leader>fm", "<cmd>FzfLua marks<cr>", desc = "search marks" },
            { "<leader>f:", "<cmd>FzfLua command_history<cr>", desc = "search command history" },
            { "<leader>f/", "<cmd>FzfLua search_history<cr>", desc = "search search history" },
        },
        config = function()
            vim.opt.guicursor:remove({ "t:block-blinkon500-blinkoff500-TermCursor" })
            require("fzf-lua").setup({
                "hide",
                winopts = {
                    backdrop = 100,
                    height = 0.6, -- % of screen height
                    width = 0.8, -- % of screen width
                    row = 0.5, -- center vertically
                    col = 0.5,
                },
                oldfiles = {
                    cwd_only = true,
                },
            })

            require("fzf-lua").register_ui_select()
        end,
    },
}
