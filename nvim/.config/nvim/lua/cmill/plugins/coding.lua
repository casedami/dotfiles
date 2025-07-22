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
        branch = "dev",
        opts = {
            autoload = false,
            autosave = false,
        },
    },
    {
        "folke/trouble.nvim",
        opts = {
            focus = true,
            modes = {
                lsp = {
                    win = { position = "bottom" },
                },
                symbols = {
                    win = { position = "bottom" },
                },
            },
        },
        cmd = "Trouble",
        keys = {
            {
                "<leader>fD",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "show all diagnostics",
            },
            {
                "<leader>fd",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "show buffer diagnostics",
            },
            {
                "<leader>fs",
                "<cmd>Trouble symbols toggle<cr>",
                desc = "show lsp symbols",
            },
            {
                "<leader>lf",
                "<cmd>Trouble lsp toggle<cr>",
                desc = "show lsp defiitions, references, etc.",
            },
            {
                "<leader>xl",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "show qf location list",
            },
            {
                "<leader>xq",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "show qf list",
            },
        },
    },
}
