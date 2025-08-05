_G.tools = {
    ui = {
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

local branch_cache = {}

---Returns the path to the root of the current file.
---@param path string
---@return string|nil
tools.path_root = function(path)
    if path == "" then
        return nil
    end

    local root = vim.b.path_root
    if root ~= nil then
        return root
    end

    local root_items = {
        ".git",
    }

    root = vim.fs.root(0, root_items)
    if root == nil then
        return nil
    end

    vim.b.path_root = root
    return root
end

---@param root string
---@return string|nil
tools.git_branch = function(root)
    if root == nil then
        return
    end

    local branch = branch_cache[root]
    if branch ~= nil then
        return branch
    end
    local cmd = table.concat({
        "do -i { git branch --show-current }",
        "| complete",
        "| get stdout",
        "| str trim",
    }, " ")

    branch = vim.fn.system(cmd)
    if branch == nil then
        return nil
    end

    branch = branch:gsub("\n", "")
    branch_cache[root] = branch

    return branch
end

tools.diagnostics_available = function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    local diagnostics = vim.lsp.protocol.Methods.textDocument_publishDiagnostics

    for _, cfg in pairs(clients) do
        if cfg.supports_method(diagnostics) then
            return true
        end
    end

    return false
end
