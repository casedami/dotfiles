local cache = {}

local function _get_contents(cwd)
    ---@type table<string[]>
    local dirs = vim.fn.systemlist(
        string.format("cd %s; ls -a | where type == dir | get name | to text", cwd)
    )
    for i, d in ipairs(dirs) do
        dirs[i] = { d .. "/\n", "String" }
    end

    ---@type table<string[]>
    local files = vim.fn.systemlist(
        string.format("cd %s; ls -a | where type == file | get name | to text", cwd)
    )
    for i, f in ipairs(files) do
        files[i] = { f .. "\n", "Normal" }
    end
    vim.cmd("redraw")
    table.insert(dirs, 1, { cwd .. "\n\n", "Function" })
    vim.list_extend(dirs, files)
    return dirs
end

local function list_dir(cwd)
    local contents = {}
    if cache[cwd] ~= nil then
        contents = cache[cwd]
    else
        contents = _get_contents(cwd)
        cache[cwd] = contents
    end

    vim.api.nvim_echo(contents, false, {})
end

-- stylua: ignore start
vim.keymap.set("n", "<leader>fe", function() list_dir(vim.fn.getcwd()) end, { desc = "Directory: list current working directory" })
vim.keymap.set("n", "<leader>fE", function() list_dir(vim.fn.expand("%:p:h")) end, { desc = "Directory: list current buffer's directory" })
