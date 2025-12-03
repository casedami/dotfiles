return {
    "saghen/blink.cmp",
    event = "VeryLazy",
    version = "*",
    config = function()
        require("blink.cmp").setup({
            cmdline = {
                keymap = {
                    preset = "none",
                    ["<Tab>"] = {
                        function(cmp)
                            if
                                cmp.is_ghost_text_visible()
                                and not cmp.is_menu_visible()
                            then
                                return cmp.accept()
                            end
                        end,
                        "show",
                        "accept",
                    },
                    ["<C-e>"] = {
                        "cancel",
                    },
                    ["<C-n>"] = { "select_next", "fallback" },
                    ["<C-p>"] = { "select_prev", "fallback" },
                },
                completion = {
                    menu = { auto_show = true },
                },
            },
            keymap = {
                preset = "none",
                ["<Tab>"] = {
                    "snippet_forward",
                    "accept",
                    "fallback",
                },
                ["<S-Tab>"] = {
                    "snippet_backward",
                },
                ["<C-e>"] = {
                    "cancel",
                },
                ["<C-n>"] = { "select_next", "fallback" },
                ["<C-p>"] = { "select_prev", "fallback" },
            },
            signature = {
                enabled = true,
                window = {
                    border = "rounded",
                },
            },
            sources = {
                default = {
                    "lsp",
                    "path",
                    "buffer",
                },
            },
            appearance = {
                kind_icons = {
                    Snippet = " ",
                    Folder = "  ",
                },
            },
            completion = {
                keyword = {
                    range = "full",
                },
                list = {
                    selection = {
                        auto_insert = true,
                    },
                },
                accept = {
                    auto_brackets = {
                        enabled = true,
                    },
                },
                menu = {
                    min_width = 20,
                    border = "rounded",
                    winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
                    draw = {
                        columns = {
                            { "kind_icon", gap = 4 },
                            { "label", gap = 4 },
                            { "source_name" },
                        },
                        components = {
                            source_name = {
                                text = function(ctx)
                                    local map = {
                                        ["lsp"] = " ",
                                        ["path"] = " ",
                                    }

                                    return map[ctx.item.source_id]
                                end,
                                highlight = "BlinkCmpSource",
                            },
                        },
                    },
                },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 100,
                    update_delay_ms = 50,
                    window = {
                        max_width = math.min(80, vim.o.columns),
                        border = "rounded",
                        winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
                    },
                },
            },
        })
    end,
}
