return {
    {
        "cdmill/neomodern.nvim",
        priority = 1000,
        branch = "dev",
        config = function()
            require("neomodern").setup({
                theme = "gyokuro",
                toggle_variant_key = "<leader>uc",
                alt_bg = false,
                cursorline_gutter = false,
                dark_gutter = false,
                plain_float = true,
                transparent = false,
                code_style = {
                    headings = "italic",
                },
                plugin = {
                    lualine = {
                        plain = false,
                    },
                    cmp = {
                        plain = true,
                    },
                },
                highlights = {
                    ["LazyNormal"] = { bg = "none" },
                    ["Statusline"] = { bg = "$alt_bg" },
                    ["StatuslineTerm"] = { bg = "$alt_bg" },
                    ["FloatBorder"] = { fg = "$operator" },
                    ["WinSeparator"] = { fg = "$operator" },
                },
            })
            require("neomodern").load()
        end,
    },
}
