-- Simple wrapper around vim sessions

local M = { path = { session = nil, dir = nil } }
vim.g.sessions_dir = vim.env.HOME .. "/.local/sessions"
vim.g.session_prefix = "session-"
vim.g.session_id_fallback = "local"

M.exclude_ids = { [vim.g.session_id_fallback] = true, test = true }

function M.init()
    local path = Utils.session_path()
    local head = vim.fn.fnamemodify(path, ":h")
    vim.system({ "mkdir", "-p", head }):wait()

    M.path.session = path
    M.path.dir = head
end

function M.sync()
    local branches = vim.fn.systemlist("git branch --format='%(refname:short)'")
    local branch_map = {}
    for _, b in ipairs(branches) do
        branch_map[b] = true
    end
    return Utils.get_session_ids(M.path.dir, function(ids)
        for _, branch in ipairs(ids) do
            if branch_map[branch] == nil then
                M.try_delete(branch)
            end
        end
    end)
end

M.utils._git_branch = function()
    local out = vim.system({ "git", "branch", "--show-current" }, { text = true })
        :wait()
    if out.code ~= 0 then
        return nil
    end

    local branch = vim.trim(out.stdout):gsub("/", "_")
    return #branch > 0 and branch or nil
end

M.utils._build_path = function(...)
    local components = { ... }
    return table.concat(components, "/")
end

M.utils._cwd_hash = function()
    local cwd = vim.fn.getcwd()
    local hash = vim.fn.sha256(cwd)
    return hash:sub(1, 8)
end

M.utils._validate_id = function(id)
    return id ~= nil and #id > 0
end

M.notif.unknown = function(id)
    vim.notify(("Unknown session: '%s'"):format(id), vim.log.levels.INFO)
end

M.notif.saved = function(id)
    vim.notify(("Saved session: '%s'"):format(id), vim.log.levels.INFO)
end

M.notif.deleted = function(id)
    vim.notify(("Deleted session: '%s'"):format(id), vim.log.levels.INFO)
end

M.session.exists = function(spath)
    spath = spath or M.session_path()
    return vim.uv.fs_stat(spath) ~= nil
end

M.session.is_valid = function(id)
    id = M.validate_id(id) and id or M.utils._git_branch() or vim.g.session_id_fallback
    return ("%s%s.vim"):format(vim.g.session_prefix, id)
end

M.session.path = function(id)
    local hash = M.utils._cwd_hash()
    local session = M.session_fname(id)
    local path = M.utils._build_path(vim.g.sessions_dir, hash, session)
    return path
end

M.session.fname = function(id)
    id = M.validate_id(id) and id or M.utils._git_branch() or vim.g.session_id_fallback
    return ("%s%s.vim"):format(vim.g.session_prefix, id)
end

M.session.ids = function(dir, on_ids)
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

M.session.save = function(id)
    -- Everytime a session is saved
    -- - the proper directory needs to be created
    -- - if no id is given, the id needs to be created
    -- - the session path needs to be created
    if not Utils.validate_id(id) then
        M.notif.unknown(id)
        return
    end
    id = #id > 0 and M.utils._build_path(M.path.dir, M.utils._session_fname(id))
        or M.path.session
    local path = M.session.path(id)
    vim.cmd("mksession! " .. id)
end

M.session.try_source = function()
    -- Everytime a session is sourced
    -- - if id is given, path needs to be built
    -- - path needs to be validated
    if M.session.exists(M.path.session) then
        vim.cmd("source " .. M.path.session)
    end
end

M.session.try_source_from_id = function(id)
    local to_source = M.utils._build_path(M.path.dir, M.session.fname(id))
    if M.session.exists(to_source) then
        vim.cmd("source " .. to_source)
    end
end

M.session.try_delete = function(args)
    local valid_args = {
        cwd = M.path.dir,
        all = vim.g.sessions_dir,
        _default = M.path.session,
    }

    local to_delete
    if valid_args[args] then
        to_delete = valid_args[args]
    elseif #args > 0 then
        to_delete = M.utils._build_path(M.path.dir, M.session.fname(args))
    else
        to_delete = valid_args._default
    end

    if to_delete then
        local out = vim.system({ "rm", "-r", to_delete })
        if out.code == 0 then
            M.notif.deleted(to_delete)
        else
            M.notif.unknown(to_delete)
        end
    end
end

M.session.list = function()
    M.session.ids(M.path.dir, function(ids)
        print(table.concat(ids, "\n"))
    end)
end

M.session.select = function()
    M.session.ids(M.path.dir, function(ids)
        if #ids == 1 then
            M.session.try_source_from_id(ids[1])
        else
            vim.ui.select(ids, { prompt = "Choose session:" }, function(choice)
                M.session.try_source_from_id(choice)
            end)
        end
    end)
end

M:init()
return M
