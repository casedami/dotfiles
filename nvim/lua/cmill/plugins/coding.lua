return {
    {
        "chomosuke/typst-preview.nvim",
        ft = "typst",
        version = "1.*",
        opts = {
            dependencies_bin = {
                ["tinymist"] = "/opt/homebrew/bin/tinymist",
            },
            -- invert_colors = "auto",
        },
    },
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        keys = {
            { "<leader>gg", "<cmd>Neogit kind=auto<cr>" },
        },
        cmd = "Neogit",
        config = true,
    },
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                "~/Developer/lua/neomodern.nvim",
                "~/Developer/lua/sesh.nvim",
            },
        },
    },
    { "Bilal2453/luvit-meta", ft = "lua" },
    {
        "cdmill/sesh.nvim",
        opts = {
            autoload = false,
            autosave = 2,
        },
    },
}
