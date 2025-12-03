vim.g.icons = {
    binary = "",
    branch = "",
    diag = {
        gutter = "",
        error = "",
        hint = "",
        info = "",
        warning = "",
    },
    diff = {
        add = "┃",
        delete = "_",
        change = "┃",
    },
    file = "",
    hamburger = "",
    location = { "󰋙", "󰫃", "󰫄", "󰫅", "󰫆", "󰫇", "󰫈" },
    lock = "󰍁",
    modified = "* ",
    neovim = "",
    newfile = " ",
    readonly = "󰛐 ",
    unnamed = "",
    venv = " ",
}

vim.g.special_bufs = {
    ["markdown"] = true,
    ["txt"] = true,
    ["help"] = true,
    ["terminal"] = true,
    ["prompt"] = true,
    ["nofile"] = true,
}

local utils = {}
function utils.diagnostics_available()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    local diagnostics = vim.lsp.protocol.Methods.textDocument_publishDiagnostics

    for _, cfg in pairs(clients) do
        if cfg:supports_method(diagnostics) then
            return true
        end
    end

    return false
end

function utils.hl_str(hl, str)
    return string.format("%%#%s#%s%%*", hl, str)
end

function utils.hl_tbl(hl, icons)
    return vim.tbl_map(function(i)
        return utils.hl_str(hl, i)
    end, icons)
end

function utils.augroup(name)
    return vim.api.nvim_create_augroup("__" .. name, { clear = true })
end

vim.g.utils = utils
