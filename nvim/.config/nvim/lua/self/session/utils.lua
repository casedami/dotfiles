local M = {}

vim.g.sessions_dir = vim.env.HOME .. "/.local/sessions"
vim.g.session_prefix = "session-"
vim.g.session_id_fallback = "local"

function M.cwd_hash()
    local cwd = vim.fn.getcwd()
    local hash = vim.fn.sha256(cwd)
    return hash:sub(1, 8)
end

function M.git_branch()
    local out = vim.system({ "git", "branch", "--show-current" }, { text = true })
        :wait()
    if out.code ~= 0 then
        return nil
    end

    local branch = vim.trim(out.stdout):gsub("/", "_")
    return #branch > 0 and branch or nil
end

function M.session_fname(id)
    id = id or M.session_id()
    return ("%s%s.vim"):format(vim.g.session_prefix, id)
end

function M.session_id()
    return M.git_branch() or vim.g.session_id_fallback
end

function M.get_session_ids(dir, on_ids)
    local sessions = vim.fn.glob(dir .. "/*.vim", false, true)

    if #sessions == 0 then
        vim.notify("No sessions found for cwd", vim.log.levels.INFO)
        return
    end

    local ids = {}
    for _, s in ipairs(sessions) do
        ids[#ids + 1] = s:match("session%-(.+)%.vim")
    end
    table.sort(ids)
    on_ids(ids)
end

function M.build_path(...)
    local components = { ... }
    return table.concat(components, "/")
end

function M.validate(spath)
    return vim.uv.fs_stat(spath) ~= nil
end

return M
