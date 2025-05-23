return {
    {
        "chomosuke/typst-preview.nvim",
        ft = "typst",
        version = "1.*",
        opts = {
            dependencies_bin = {
                -- ["tinymist"] = "/opt/homebrew/bin/tinymist",
            },
            invert_colors = "auto",
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
