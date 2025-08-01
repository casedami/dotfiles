return {
    {
        "chomosuke/typst-preview.nvim",
        ft = "typst",
        version = "1.*",
        opts = {
            debug = true,
            invert_colors = "auto",
            dependencies_bin = {
                ["websocat"] = "/home/caseymiller/.cargo/bin/websocat",
            },
        },
    },
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                { path = "/home/cdm/.config/nvim/lua/cmill/core/globals.lua" },
            },
        },
    },
    {
        "cdmill/sesh.nvim",
        cmd = "Sesh",
        opts = {
            autoload = false,
            autosave = {
                enabled = false,
                criteria = {
                    splits = 2,
                },
            },
            use_branch = true,
        },
        keys = {
            { "<leader>S", "<cmd>Sesh<cr>", { desc = "select session" } },
            { "<leader>ss", "<cmd>Sesh save<cr>", { desc = "save session for cwd" } },
            { "<leader>sd", "<cmd>Sesh del<cr>", { desc = "delete session for cwd" } },
            {
                "<leader>sD",
                "<cmd>Sesh clean<cr>",
                { desc = "delete all saved sessions" },
            },
            { "<leader>sl", "<cmd>Sesh load<cr>", { desc = "load session for cwd" } },
        },
    },
}
