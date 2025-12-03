-- Simple wrapper around vim sessions

vim.g.sessions_dir = vim.env.HOME .. "/.local/sessions"

local function _get_cwd_hash()
    local cwd = vim.fn.getcwd()
    local hash = vim.fn.sha256(cwd)
    return hash:sub(1, 8)
end

local function _format_session_name(id)
    return ("session-%s.vim"):format(id)
end

local function _extract_session_ids(sessions)
    local ids = {}
    for _, s in ipairs(sessions) do
        ids[#ids + 1] = s:match("session%-(.+)%.vim")
    end
    return ids
end

local function _get_session_ids(dir, on_ids)
    local sessions = vim.fn.glob(dir .. "/*.vim", false, true)

    if #sessions == 0 then
        vim.notify("No sessions found for cwd", vim.log.levels.INFO)
        return
    end

    local ids = _extract_session_ids(sessions)
    table.sort(ids)
    on_ids(ids)
end

local function _build_path(components)
    return table.concat(components, "/")
end

local M = { path = { session = nil, dir = nil } }

function M.init()
    local hash = _get_cwd_hash()
    local sdir_local = ("%s/%s"):format(vim.g.sessions_dir, hash)
    vim.system({ "mkdir", "-p", sdir_local }):wait()

    local out = vim.system({ "git", "branch", "--show-current" }, { text = true })
        :wait()
    if out.code ~= 0 then
        return hash, nil
    end

    local branch = vim.trim(out.stdout):gsub("/", "_")
    local id = #branch > 0 and branch or "local"
    local session = _format_session_name(id)
    M.path.session = _build_path({ vim.g.sessions_dir, hash, session })
    M.path.dir = _build_path({ vim.g.sessions_dir, hash })
end

function M.validate(s)
    return vim.uv.fs_stat(s) ~= nil
end

function M:save()
    vim.cmd("mksession! " .. self.path.session)
end

function M:try_source(s)
    local to_source = s or self.path.session
    if self.validate(to_source) then
        vim.cmd("source " .. to_source)
    end
end

function M:try_delete(args)
    local valid_args = {
        cwd = self.path.dir,
        all = vim.g.sessions_dir,
    }
    local to_delete = valid_args[args] or self.path.session
    if to_delete then
        vim.fs.rm(to_delete)
    end
end

function M:list()
    _get_session_ids(self.path.dir, function(ids)
        print(table.concat(ids, "\n"))
    end)
end

function M:select()
    local function try_source_choice(c)
        local spath = _build_path({ self.path.dir, _format_session_name(c) })
        self:try_source(spath)
    end

    _get_session_ids(self.path.dir, function(ids)
        if #ids == 1 then
            try_source_choice(ids[1])
        else
            vim.ui.select(ids, { prompt = "Choose session:" }, function(choice)
                try_source_choice(choice)
            end)
        end
    end)
end

function M:sync()
    -- TODO remove any sessions for branches that no longer exist
end

M:init()
return M
