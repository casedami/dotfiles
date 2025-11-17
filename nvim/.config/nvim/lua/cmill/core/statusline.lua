local icons_hl = Utils.hl_tbl({
    binary = { "DiagnosticHint", Utils.icons.binary },
    branch = { "Type", Utils.icons.branch },
    error = { "DiagnosticError", Utils.icons.diag.error },
    fileinfo = { "DiagnosticHint", Utils.icons.hamburger },
    modified = { "TODO", Utils.icons.modified },
    nomodifiable = { "DiagnosticWarn", Utils.icons.lock },
    readonly = { "DiagnosticHint", Utils.icons.readonly },
    warn = { "DiagnosticWarn", Utils.icons.diag.warning },
    venv = { "@property", Utils.icons.venv },
    location = { "@variable", Utils.icons.location },
})

local SLSectionBuilder = {}
function SLSectionBuilder:new()
    local M = {
        _pad = " ",
        _sep = "%=",
        view = {},
    }

    setmetatable(M, { __index = SLSectionBuilder })
    return M
end

---@param mod string
function SLSectionBuilder:add(mod)
    table.insert(self.view, mod)
    table.insert(self.view, self._pad)
    return self
end

function SLSectionBuilder:build()
    local section = table.concat(self.view)
    self.view = {}
    self._pad = " "
    self._sep = "%="
    return section
end

function SLSectionBuilder:diagnostics()
    if not Utils.diagnostics_available() then
        return self
    end

    local diag_count = vim.diagnostic.count()
    local err_count = diag_count[1] or 0
    local warn_count = diag_count[2] or 0

    if err_count > 0 or warn_count > 0 then
        local mod = table.concat({
            icons_hl.error,
            tostring(err_count),
            icons_hl.warn,
            tostring(warn_count),
        }, " ")
        self:add(mod)
    end
    return self
end

local git_cache = {}
function SLSectionBuilder:git()
    local root = vim.fs.root(0, ".git")
    if root == nil then
        return self
    end
    if git_cache[root] ~= nil then
        self:add(git_cache[root])
        return self
    end
    local branch = vim.fn.system("flamingo git")
    if #branch > 0 then
        local mod = table.concat({
            icons_hl.branch,
            Utils.hl_str("Type", branch),
        }, " ")
        git_cache[root] = mod
        self:add(mod)
    end
    return self
end

function SLSectionBuilder:flines()
    local nlines = vim.fn.line("$")
    local mod = icons_hl.fileinfo .. " " .. nlines
    self:add(mod)
    return self
end

function SLSectionBuilder:floc()
    if Utils.special_bt[vim.bo.buftype] then
        return self
    end
    local nlines = vim.fn.line("$")

    local winheight = vim.fn.winheight(0)

    local idx = nil
    -- If window is taller than file, use last icon
    if winheight >= nlines then
        idx = #Utils.icons.location
    else
        local loc = vim.fn.getpos(".")[2]
        idx = math.floor((loc - 1) / nlines * #Utils.icons.location) + 1
    end

    local mod = table.concat({
        icons_hl.location[idx],
        Utils.hl_str("@variable", "%P"),
    }, " ")
    self:add(mod)
    return self
end

function SLSectionBuilder:fmeta()
    local buf_num = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
    local readonly = vim.api.nvim_get_option_value("readonly", { buf = buf_num })
            and icons_hl.readonly
        or ""
    local nomod = vim.api.nvim_get_option_value("modifiable", { buf = buf_num }) and ""
        or icons_hl.nomodifiable
    local mod = table.concat({
        readonly,
        self._pad,
        nomod,
    })
    self:add(mod)
    return self
end

function SLSectionBuilder:fsize()
    local fsize = tostring(vim.fn.getfsize(vim.fn.bufname()))
    if fsize == "-1" then
        return self
    end
    fsize = fsize:gsub("(%d+)%d%d%d$", "%1k")
    local mod = icons_hl.binary .. " " .. fsize
    self:add(mod)
    return self
end

function SLSectionBuilder:pad(count)
    count = count or 1
    for _ = 1, count do
        self:add(self._pad)
    end
    return self
end

local path_cache = {}
function SLSectionBuilder:path()
    local fname = vim.api.nvim_buf_get_name(0)
    local formatted = nil
    local cases = {
        terminal = "",
        nofile = "",
        help = "help pages",
    }
    if cases[vim.bo.buftype] then
        self:add(cases[vim.bo.buftype])
        return self
    end

    if path_cache[fname] ~= nil then
        self:add(path_cache[fname])
        return self
    end

    formatted = vim.fn.system("flamingo path -f " .. fname)
    local buf_num = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
    local modified = vim.api.nvim_get_option_value("modified", { buf = buf_num })
            and icons_hl.modified
        or ""
    local tail = vim.fn.fnamemodify(fname, ":t")
    local icon, hl = require("mini.icons").get("file", tail)
    icon = tail ~= "" and Utils.hl_str(hl, icon) or ""

    local mod = table.concat({
        formatted,
        icon,
        modified,
    }, self._pad)
    path_cache[fname] = mod
    self:add(mod)
    return self
end

function SLSectionBuilder:prefix()
    local mod = Utils.icons.neovim
    if vim.api.nvim_eval("len(gettabinfo())") > 1 then
        mod = vim.fn.tabpagenr()
    end
    mod = Utils.hl_str("@lsp.typemod.keyword.documentation", mod)
    self:add(mod)
    return self
end

function SLSectionBuilder:sep()
    self:add(self._sep)
    return self
end

function SLSectionBuilder:set_pad(n)
    self._pad = string.rep(" ", n)
    return self
end

function SLSectionBuilder:user()
    self:add(
        Utils.hl_str(
            "@lsp.typemod.keyword.documentation",
            vim.uv.os_get_passwd()["username"]
        )
    )
    return self
end

function SLSectionBuilder:venv()
    local venv = os.getenv("VIRTUAL_ENV")
    if venv then
        local name = vim.fn.fnamemodify(venv, ":t")
        local mod = table.concat({
            icons_hl.venv,
            Utils.hl_str("@property", name),
        })
        self:add(mod)
    end
    return self
end

local M = {}

M.render = function()
    local sb = SLSectionBuilder:new()
    local left = sb:pad()
        :set_pad(2)
        :prefix()
        :user()
        :venv()
        :git()
        :set_pad(1)
        :path()
        :fmeta()
        :build()
    local right = sb:set_pad(2):diagnostics():fsize():flines():floc():build()

    return table.concat({ left, right }, sb._sep)
end

vim.o.statusline = "%!v:lua.require('cmill.core.statusline').render()"

return M
