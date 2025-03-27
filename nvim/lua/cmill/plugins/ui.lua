local statusline_components = {
    git_branch = {
        "branch",
        icon = "",
    },
    date = {
        "datetime",
        style = "%Y-%m-%d",
        color = { fg = "#88888f" },
    },
    errs = {
        "diagnostics",
        sections = { "error", "warn" },
        symbols = {
            error = "󰅖",
            warn = "",
        },
    },
    git_diff = {
        "diff",
    },
    fname = {
        "filename",
        path = 3,
        fmt = function(str)
            local ftype = {
                lazy = "Lazy",
                fugitive = "Git",
                dashboard = "Dashboard",
                snacks_picker_input = "Explorer",
                snacks_picker_list = "Explorer",
            }
            local btype = {
                terminal = "terminal",
                quickfix = "quickfix",
            }
            return ftype[vim.bo.filetype] or btype[vim.bo.buftype] or str
        end,
        symbols = {
            modified = " ",
            readonly = " ",
            unnamed = "󰄰 ",
            newfile = "󱇬 ",
        },
    },
    fsize = {
        "filesize",
    },
    ftype = {
        "filetype",
        colored = false,
        icon_only = true,
    },
    user = {
        function()
            return vim.uv.os_get_passwd()["username"]
        end,
    },
    loc = {
        "location",
    },
    modes = {
        "mode",
        fmt = function(str)
            return str:sub(1, 3)
        end,
    },
    nvim_icon = {
        function()
            return ""
        end,
        color = function()
            local palette = require("neomodern.terminal").colors(false)
            return { fg = palette.green }
        end,
    },
    prog = {
        "progress",
    },
    tabs = {
        function()
            return vim.fn.tabpagenr()
        end,
        cond = function()
            return vim.api.nvim_eval("len(gettabinfo())") > 1
        end,
    },
    time = {
        "datetime",
        style = "%H:%M:%S",
    },
}

return {
    {
        "cdmill/focus.nvim",
        cmd = { "Focus", "Zen", "Narrow" },
        opts = {
            window = {
                width = 100,
            },
        },
    },
    {
        "j-hui/fidget.nvim",
        event = "BufReadPost",
        config = function()
            require("fidget").setup({
                logger = {
                    level = vim.log.levels.INFO,
                },
                notification = {
                    window = {
                        winblend = 0,
                    },
                },
            })
            local banned_messages = { "No information available" }
            vim.notify = function(msg, ...)
                for _, banned in ipairs(banned_messages) do
                    if msg == banned then
                        return
                    end
                end
                return require("fidget").notify(msg, ...)
            end
        end,
    },
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufRead", "BufNewFile" },
        opts = {
            culhl = true,
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

        -- navigation
        -- stylua: ignore
        map("n", "]h", function()
          if vim.wo.diff then return "[h" end
          vim.schedule(function() gs.next_hunk() end)
          return "<Ignore>"
        end, { expr = true })

        -- stylua: ignore
        map("n", "[h", function()
          if vim.wo.diff then return "]h" end
          vim.schedule(function() gs.prev_hunk() end)
          return "<Ignore>"
        end, { expr = true })

        -- actions
        -- stylua: ignore start
        map("n", "<leader>gss", gs.stage_hunk)
        map("v", "<leader>gss", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end)
        map("n", "<leader>gu", gs.undo_stage_hunk)
        map("n", "<leader>gr", gs.reset_hunk)
        map("v", "<leader>gr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end)
        map("n", "<leader>gS", gs.stage_buffer)
        map("n", "<leader>gR", gs.reset_buffer)
        map("n", "<leader>gd", gs.diffthis)
        map("n", "<leader>gt", gs.toggle_deleted)
        map("n", "<leader>gb", function() gs.blame_line({ full = true }) end)
                -- stylua: ignore end
            end,
        },
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = function()
            local setup = {
                options = {
                    icons_enabled = true,
                    theme = "neomodern",
                    -- section_separators = { left = "", right = "" },
                    -- component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                    component_separators = { left = "", right = "" },
                    -- section_separators = { left = "", right = "" },
                    -- component_separators = { left = "", right = "" },
                    disabled_filetypes = {},
                    ignore_focus = {},
                    always_divide_middle = true,
                    globalstatus = true,
                    refresh = {
                        statusline = 100,
                    },
                },
                sections = {
                    lualine_a = {
                        statusline_components.modes,
                    },
                    lualine_b = {
                        statusline_components.git_branch,
                        statusline_components.git_diff,
                    },
                    lualine_c = {
                        -- components.nvim_icon,
                        statusline_components.errs,
                        statusline_components.fname,
                    },
                    lualine_x = {
                        statusline_components.fsize,
                        statusline_components.ftype,
                    },
                    lualine_y = {
                        statusline_components.loc,
                        statusline_components.prog,
                    },
                    lualine_z = {
                        statusline_components.tabs,
                    },
                },
            }
            return setup
        end,
    },
}
