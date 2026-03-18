vim.g.icons = {
    diag = {
        gutter = "",
        error = " ",
        hint = "",
        info = "",
        warning = " ",
    },
    diff = {
        add = "┃",
        delete = "_",
        change = "┃",
    },
    location = { "▔", "🮂", "🮃", "🮑", "🮒", "▃", "▂", "▁" },
    lock = "󰍁",
    modified = "*",
    neovim = " ",
    newfile = " ",
    readonly = "󰛐 ",
    unnamed = "",
}

local utils = {}
function utils.diagnostics_available()
    return #vim.lsp.get_clients({ bufnr = 0 }) > 0
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

function utils.get_dir_contents(dir)
    local result = {
        ---@type table<string[]>
        dirs = {},
        ---@type table<string[]>
        files = {},
    }

    local dirs = vim.fn.systemlist(
        string.format("cd %s; ls -a | where type == dir | get name | to text", dir)
    )
    result.dirs = vim.tbl_map(function(s)
        return s .. "/"
    end, dirs)

    ---@type table<string[]>
    result.files = vim.fn.systemlist(
        string.format("cd %s; ls -a | where type == file | get name | to text", dir)
    )
    return result
end

vim.g.utils = utils
vim.g.proj_dir = vim.env.HOME .. "/dev"
