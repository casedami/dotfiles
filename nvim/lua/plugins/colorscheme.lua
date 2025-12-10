return {
    {
        "casedami/neomodern.nvim",
        priority = 1000,
        branch = "dev",
        config = function()
            require("neomodern").setup({
                theme = "iceclimber",
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
                    ["DiffText"] = { fg = "$diag_blue", bg = "#24282b", fmt = "bold" },
                    ["FzfLuaBorder"] = { fg = "$operator" },
                    ["FzfLuaBufFlagCur"] = { fg = "$alt" },
                    ["FzfLuaBufFlagAlt"] = { fg = "$alt" },
                    ["FzfLuaTitleFlags"] = { fg = "$alt" },
                    ["FzfLuaHeaderText"] = { fg = "$alt" },
                    ["FzfLuaHeaderBind"] = { fg = "$number" },
                    ["FzfLuaLiveSym"] = { fg = "$type" },
                    ["FzfLuaLivePrompt"] = { fg = "$type" },
                    ["FzfLuaPathLineNr"] = { fg = "$alt" },
                    ["FzfLuaPathColNr"] = { fg = "$fg" },
                },
            })
            require("neomodern").load()
        end,
    },
}
