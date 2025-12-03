-- Simple wrapper around vim sessions

local M = { path = { session = nil, dir = nil } }
local Utils = require("session.utils")

function M.init()
    local hash = Utils.cwd_hash()
    local sdir_local = Utils.build_path(vim.g.sessions_dir, hash)
    vim.system({ "mkdir", "-p", sdir_local }):wait()

    local session = Utils.session_fname()
    M.path.session = Utils.build_path(sdir_local, session)
    M.path.dir = sdir_local
end

function M:save()
    vim.cmd("mksession! " .. self.path.session)
end

function M:try_source(s)
    local to_source = s or self.path.session
    if Utils.validate(to_source) then
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
    Utils.get_session_ids(self.path.dir, function(ids)
        print(table.concat(ids, "\n"))
    end)
end

function M:select()
    local function try_source_choice(c)
        local spath = Utils.build_path({ self.path.dir, Utils.session_fname(c) })
        self:try_source(spath)
    end

    Utils.get_session_ids(self.path.dir, function(ids)
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
