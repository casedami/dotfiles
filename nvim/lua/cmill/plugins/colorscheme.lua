return {
    {
        "cdmill/neomodern.nvim",
        priority = 1000,
        config = function()
            require("neomodern").setup({
                theme = "iceclimber",
                cycle_theme_key = "<leader>cc",
                cycle_theme_list = {
                    "iceclimber",
                    "coffeecat",
                    "darkforest",
                    "roseprime",
                },
                alt_culnr_hl = false,
                favor_treesitter_hl = false,
                toggle_mode_key = "<leader>uc",
                code_style = {
                    headings = "italic",
                },
                cursorline_gutter = false,
                dark_gutter = false,
                transparent = false,
                plain_float = true,
                show_eob = false,
                colored_docstrings = true,
                plugin = {
                    lualine = {
                        plain = false,
                    },
                    cmp = {
                        plain = true,
                    },
                    telescope = "bordered",
                },
                highlights = {
                    ["LazyNormal"] = { bg = "none" },
                    -- ["Normal"] = { bg = "#000000" },
                    -- ["FoldColumn"] = { bg = "#000000" },
                },
            })
            require("neomodern").load()
        end,
    },
}
