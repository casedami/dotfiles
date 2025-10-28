return {
    {
        "casedami/sesh.nvim",
        cmd = "Sesh",
        config = function()
            require("sesh").setup({
                autoload = false,
                autosave = {
                    enabled = false,
                    criteria = {
                        splits = 2,
                    },
                },
                use_branch = true,
            })
            -- stylua: ignore start
            vim.keymap.set("n", "<leader>S", "<cmd>Sesh<cr>", { desc = "Session: select" })
            vim.keymap.set("n", "<leader>ss", "<cmd>Sesh save<cr>", { desc = "Session: save for cwd" })
            vim.keymap.set("n", "<leader>sd", "<cmd>Sesh del<cr>", { desc = "Session: delete for cwd" })
            vim.keymap.set("n", "<leader>sl", "<cmd>Sesh load<cr>", { desc = "Session: load session for cwd" })
            vim.keymap.set("n", "<leader>sD", "<cmd>Sesh clean<cr>", { desc = "Session: delete all" })
            -- stylua: ignore end
        end,
    },
}
