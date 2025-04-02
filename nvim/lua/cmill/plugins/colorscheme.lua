return {
    {
        "cdmill/neomodern.nvim",
        priority = 1000,
        config = function()
            require("neomodern").setup({
                theme = "iceclimber",
                favor_treesitter_hl = false,
                toggle_mode_key = "<leader>uc",
                code_style = {
                    headings = "italic",
                },
                cursorline_gutter = false,
                transparent = false,
                plain_float = true,
                show_eob = true,
                colored_docstrings = true,
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
                    -- ["FoldColumn"] = { bg = "#000000" },
                },
            })
            require("neomodern").load()
        end,
    },
}
