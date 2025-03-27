return {
    {
        "NeogitOrg/neogit",
        keys = {
            { "<leader>gg", "<cmd>Neogit kind=auto<cr>" },
        },
        cmd = "Neogit",
        config = true,
    },
    {
        "nvim-lua/plenary.nvim",
        lazy = true,
    },
    {
        "danymat/neogen",
        event = "LspAttach",
        config = function()
            require("neogen").setup({
                snippet_engine = "nvim",
            })
        end,
    },
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                "~/Developer/lua/neomodern.nvim/",
            },
        },
    },
    { "Bilal2453/luvit-meta", ft = "lua" },
}
