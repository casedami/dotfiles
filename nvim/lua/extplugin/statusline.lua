local prefix = function()
    local comp = vim.g.icons.neovim
    if vim.api.nvim_eval("len(gettabinfo())") > 1 then
        comp = tostring(vim.fn.tabpagenr()) .. " "
    end
    return comp
end

local path = function()
    local abs = vim.api.nvim_buf_get_name(0)
    local rel = vim.fn.fnamemodify(abs, ":.")
    local bufname = (rel == abs) and abs
        or (vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. "/" .. rel)

    local head = vim.fn.fnamemodify(bufname, ":h")
    local display_head = head == "." and "" or head .. "/"

    local bufnr = vim.api.nvim_get_current_buf()
    local readonly = vim.api.nvim_get_option_value("readonly", { buf = bufnr })
            and vim.g.icons.readonly
        or ""
    local nomod = vim.api.nvim_get_option_value("modifiable", { buf = bufnr }) and ""
        or vim.g.icons.noodifiable
    local modified = vim.api.nvim_get_option_value("modified", { buf = bufnr })
            and vim.g.icons.modified
        or ""

    return table.concat({
        display_head,
        vim.fn.fnamemodify(bufname, ":t"),
        modified,
        readonly,
        nomod,
    })
end

local bufloc = function()
    return table.concat({
        "%P",
        "/",
        vim.fn.line("$"),
    }, " ")
end

require("lualine").setup({
    options = {
        icons_enabled = true,
        theme = "neomodern",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
            statusline = { "nofile" },
            winbar = {},
        },
        always_show_tabline = false,
        globalstatus = true,
        refresh = {
            statusline = 1000,
            refresh_time = 16,
            events = {
                "WinEnter",
                "BufEnter",
                "BufWritePost",
                "SessionLoadPost",
                "FileChangedShellPost",
                "VimResized",
                "Filetype",
                "CursorMoved",
                "CursorMovedI",
                "ModeChanged",
                "DirChanged",
            },
        },
    },
    sections = {
        lualine_a = { { prefix, padding = { left = 1, right = 0 } } },
        lualine_b = { { "branch", icons_enabled = false } },
        lualine_c = {
            {
                path,
                cond = function()
                    local ignore = {
                        terminal = true,
                        prompt = true,
                        nofile = true,
                        help = true,
                        fzf = true,
                    }
                    return not (ignore[vim.bo.buftype] or ignore[vim.bo.filetype])
                end,
                color = { gui = "italic" },
            },
            { "%S", color = "Todo" },
        },
        lualine_x = {},
        lualine_y = {
            {
                "diagnostics",
                symbols = {
                    error = vim.g.icons.diag.error,
                    warn = vim.g.icons.diag.warning,
                    info = vim.g.icons.diag.warning,
                    hint = vim.g.icons.diag.warning,
                },
            },
        },
        lualine_z = { bufloc },
    },
})
