---@class ConfigUtils
---@field icons table
---@field text_ft table
---@field special_bt table
---@field path_root function | nil
---@field git_branch function | nil
---@field diagnostics_available function | nil
---@field hl_str function | nil
---@field hl_tbl function | nil

---@type ConfigUtils
_G.Utils = {
    icons = {
        binary = "",
        branch = "",
        diag = {
            gutter = "",
            error = "",
            hint = "",
            info = "",
            warning = "",
        },
        ldots = "...",
        cdots = "󰑀 ",
        file = "",
        hamburger = "",
        location = { "󰋙", "󰫃", "󰫄", "󰫅", "󰫆", "󰫇", "󰫈" },
        lock = "󰍁",
        modified = "* ",
        neovim = "",
        newfile = " ",
        readonly = "󰛐 ",
        unnamed = "",
        venv = "󰇄",
    },
    text_ft = {
        ["markdown"] = true,
        ["txt"] = true,
        ["help"] = true,
    },
    special_bt = {
        ["terminal"] = true,
        ["prompt"] = true,
        ["nofile"] = true,
    },
}

function Utils.diagnostics_available()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    local diagnostics = vim.lsp.protocol.Methods.textDocument_publishDiagnostics

    for _, cfg in pairs(clients) do
        if cfg:supports_method(diagnostics) then
            return true
        end
    end

    return false
end

function Utils.hl_str(hl, str)
    return "%#" .. hl .. "#" .. str .. "%*"
end

function Utils.hl_tbl(icon_list)
    local new = {}

    for name, list in pairs(icon_list) do
        local val = nil
        if type(list[2]) == "table" then
            val = {}
            for i, icon in ipairs(list[2]) do
                val[i] = Utils.hl_str(list[1], icon)
            end
        else
            val = Utils.hl_str(list[1], list[2])
        end
        new[name] = val
    end

    return new
end
