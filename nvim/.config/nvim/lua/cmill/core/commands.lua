-- grep for todo items
vim.api.nvim_create_user_command("Todo", function()
    vim.cmd(
        [[ lua require("fzf-lua").live_grep({no_esc=true, search="(TODO|BUG|FIXME|WARN|NOTE|MARK)"}) ]]
    )
end, { desc = "Grep TODOs", nargs = 0 })

local function find_session_files(opts)
    local root = vim.fs.root(0, ".git")
    local sessions = vim.fs.find(
        { "Session.vim" },
        { limit = opts.limit, type = "file", path = root }
    )
    if #sessions == 1 then
        return sessions
    end
    return #sessions > 0 and sessions or nil
end

vim.api.nvim_create_user_command("LoadSessionQuiet", function()
    local sfiles = find_session_files({ limit = 1 })
    if sfiles ~= nil and #sfiles == 1 then
        vim.cmd(string.format("source %s", sfiles[1]))
    end
end, { nargs = 0 })

vim.api.nvim_create_user_command("DelSessionQuiet", function(opts)
    local limit = opts.bang and math.huge or nil
    local sfiles = find_session_files({ limit = limit })
    if sfiles == nil then
        return
    end
    for _, s in ipairs(sfiles) do
        vim.fs.rm(s)
    end
end, { bang = true })
