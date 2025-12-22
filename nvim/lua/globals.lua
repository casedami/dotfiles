vim.g.icons = {
    binary = "",
    branch = "",
    cmd = "󰘳 ",
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
    neovim = " ",
    newfile = " ",
    readonly = "󰛐 ",
    sep = "┃",
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
    ---@type string
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

function utils.augroup(name)
    return vim.api.nvim_create_augroup("__" .. name, { clear = true })
end

function utils.cd_root()
    local root = vim.fs.root(vim.fn.expand("%"), ".git")
    if root then
        vim.cmd.lcd(root)
        vim.cmd.pwd()
    else
        vim.notify("No .git root found", vim.log.levels.INFO)
    end
end

function utils.import_cfg(dir)
    local files = vim.fn.globpath(
        string.format("%s/lua/%s", vim.fn.stdpath("config"), dir),
        "*.lua",
        false,
        true
    )

    for _, f in ipairs(files) do
        require(string.format("%s.%s", dir, vim.fn.fnamemodify(f, ":t:r")))
    end
end

vim.g.utils = utils
vim.g.proj_dir = vim.env.HOME .. "/dev"
