local cache = {}

local function hl_content(cwd, dirs, files)
    local result = {}
    result[1] = { cwd .. "\n\n", "Function" }
    for _, d in ipairs(dirs) do
        result[#result + 1] = { d .. "\n", "String" }
    end

    for _, f in ipairs(files) do
        result[#result + 1] = { f .. "\n", "Normal" }
    end
    return result
end

local function list_dir(cwd)
    local result = {}
    if cache[cwd] ~= nil then
        result = cache[cwd]
    else
        local contents = vim.g.utils.get_dir_contents(cwd)
        result = hl_content(cwd, contents.dirs, contents.files)
        cache[cwd] = result
    end

    vim.cmd("redraw")
    vim.api.nvim_echo(result, false, {})
end

-- stylua: ignore start
vim.keymap.set("n", "<leader>fe", function() list_dir(vim.fn.getcwd()) end, { desc = "Directory: list current working directory" })
vim.keymap.set("n", "<leader>fE", function() list_dir(vim.fn.expand("%:p:h")) end, { desc = "Directory: list current buffer's directory" })

vim.api.nvim_create_autocmd({"ShellCmdPost", "BufWritePost"}, {
  group = vim.g.utils.augroup("listdir"),
  desc = "Invalidate cache after a shell cmd",
  callback= function()
    cache = {}
  end
})
