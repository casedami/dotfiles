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
}
