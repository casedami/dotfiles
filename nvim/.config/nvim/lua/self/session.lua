-- Simple wrapper around vim sessions

vim.g.sessions_dir = vim.env.HOME .. "/.local/sessions"

local function _get_cwd_hash()
    local cwd = vim.fn.getcwd()
    local hash = vim.fn.sha256(cwd)
    return hash:sub(1, 8)
end

local function _setup()
    local hash = _get_cwd_hash()
    local sdir_local = ("%s/%s"):format(vim.g.sessions_dir, hash)
    vim.system({ "mkdir", "-p", sdir_local }):wait()

    local out = vim.system({ "git", "branch", "--show-current" }, { text = true })
        :wait()
    if out.code ~= 0 then
        return hash, nil
    end

    local branch = vim.trim(out.stdout)
    local sname = ("session-%s.vim"):format(branch)
    return hash, sname
end

local hash, name = _setup()
local M = {
    hash = hash,
    name = name,
}

M.current_session = M.name and ("%s/%s/%s"):format(vim.g.sessions_dir, M.hash, M.name)
    or nil
M.current_dir = M.name and ("%s/%s"):format(vim.g.sessions_dir, M.hash) or nil

function M:try_save()
    if self.current_session then
        vim.cmd("mksession! " .. self.current_session)
    end
end

function M:try_source()
    if self.current_session then
        vim.cmd("source " .. self.current_session)
    end
end

function M:try_delete(args)
    local valid_args = {
        cwd = self.current_dir,
        all = vim.g.sessions_dir,
    }
    local to_delete = valid_args[args] or self.current_session
    if to_delete then
        vim.fs.rm(to_delete)
    end
end

function M:list()
    local sessions = {}
    for s, _ in vim.fs.dir(self.current_dir) do
        table.insert(sessions, s)
    end

    if #sessions == 0 then
        vim.notify("No sessions found for cwd", vim.log.levels.INFO)
        return
    end

    table.sort(sessions)

    local lines = {}
    for i, s in ipairs(sessions) do
        local marker = (s == self.name) and "%" or " "
        table.insert(lines, ("%s%3d: %s"):format(marker, i, name))
    end

    print(table.concat(lines, "\n"))
end

return M
