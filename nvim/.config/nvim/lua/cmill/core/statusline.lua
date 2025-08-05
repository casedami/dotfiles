local function hl_str(hl, str)
    return "%#" .. hl .. "#" .. str .. "%*"
end

local function hl_icons(icon_list)
    local icons = {}

    for name, list in pairs(icon_list) do
        local val = nil
        if type(list[2]) == "table" then
            val = {}
            for i, icon in ipairs(list[2]) do
                val[i] = hl_str(list[1], icon)
            end
        else
            val = hl_str(list[1], list[2])
        end
        icons[name] = val
    end

    return icons
end

local icons_raw = tools.ui.icons
local icons_hl = hl_icons({
    binary = { "DiagnosticHint", icons_raw.binary },
    branch = { "Type", icons_raw.branch },
    error = { "DiagnosticError", icons_raw.diag.error },
    fileinfo = { "DiagnosticHint", icons_raw.hamburger },
    modified = { "TODO", icons_raw.modified },
    nomodifiable = { "DiagnosticWarn", icons_raw.lock },
    readonly = { "DiagnosticHint", icons_raw.readonly },
    warn = { "DiagnosticWarn", icons_raw.diag.warning },
    venv = { "@property", icons_raw.venv },
    location = { "@variable", icons_raw.location },
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
    if not tools.diagnostics_available() then
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

function SLSectionBuilder:git(root)
    local branch = tools.git_branch(root)
    local max_repo_len = 10

    if branch then
        if #branch > max_repo_len then
            branch =
                string.format("%s%s", branch:sub(1, max_repo_len - 1), icons_raw.cdots)
        end
        local mod = table.concat({
            icons_hl.branch,
            hl_str("Type", branch),
        }, " ")
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
    if tools.special_bt[vim.bo.buftype] then
        return self
    end
    local nlines = vim.fn.line("$")

    local winheight = vim.fn.winheight(0)

    local idx = nil
    -- If window is taller than file, use last icon
    if winheight >= nlines then
        idx = #icons_raw.location
    else
        local loc = vim.fn.getpos(".")[2]
        idx = math.floor((loc - 1) / nlines * #icons_raw.location) + 1
    end

    local mod = table.concat({
        icons_hl.location[idx],
        hl_str("@variable", "%P"),
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

function SLSectionBuilder:path(root, fname)
    local path = fname:gsub("^/.+/caseymiller/", "~/")
    if root == nil then
        self:add(path)
        return self
    end
    local buf_num = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
    local modified = vim.api.nvim_get_option_value("modified", { buf = buf_num })
            and icons_hl.modified
        or ""
    local tail = vim.fn.fnamemodify(path, ":t")
    local icon, hl = require("mini.icons").get("file", tail)
    icon = tail ~= "" and hl_str(hl, icon) or ""
    local tail_and_icon = table.concat({ tail, self._pad, icon, self._pad, modified })

    if vim.bo.buftype == "help" then
        self:add(tail_and_icon)
        return
    end

    local head = vim.fn.fnamemodify(path, ":h")
    local max_head_len = 15
    local width = vim.api.nvim_win_get_width(0)

    if width < max_head_len + #head + #tail_and_icon then
        head = ""
    elseif #head > max_head_len then
        local parts = vim.split(vim.trim(head, "/"), "/")
        head = #parts >= 2
                and string.format(
                    "%s/%s/%s/",
                    icons_raw.ldots,
                    parts[#parts - 1],
                    parts[#parts]
                )
            or vim.fn.pathshorten(head, 1)
    end

    local mod = table.concat({
        head,
        tail_and_icon,
    })
    self:add(mod)
    return self
end

function SLSectionBuilder:prefix()
    local mod = icons_raw.neovim
    if vim.api.nvim_eval("len(gettabinfo())") > 1 then
        mod = vim.fn.tabpagenr()
    end
    mod = hl_str("@lsp.typemod.keyword.documentation", mod)
    self:add(mod)
    return self
end

function SLSectionBuilder:section(s)
    self._curr = s
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
        hl_str("@lsp.typemod.keyword.documentation", vim.uv.os_get_passwd()["username"])
    )
    return self
end

function SLSectionBuilder:venv()
    local venv = os.getenv("VIRTUAL_ENV")
    if venv then
        local name = vim.fn.fnamemodify(venv, ":t")
        local mod = table.concat({
            icons_hl.venv,
            hl_str("@property", name),
        })
        self:add(mod)
    end
    return self
end

local M = {}

--- Creates statusline
--- @return string statusline text to be displayed
M.render = function()
    local root = nil
    local fname = vim.api.nvim_buf_get_name(0)
    local cases = {
        terminal = "",
        nofile = "",
        help = "help pages",
    }
    if cases[vim.bo.buftype] then
        fname = cases[vim.bo.buftype]
    else
        root = tools.path_root(fname)
    end

    local sb = SLSectionBuilder:new()
    local sections = {
        sb:pad()
            :prefix()
            :set_pad(2)
            :user()
            :venv()
            :git(root)
            :path(root, fname)
            :set_pad(1)
            :fmeta()
            :build(),
        sb:set_pad(2):diagnostics():fsize():flines():floc():build(),
    }

    return table.concat(sections, sb._sep)
end

vim.o.statusline = "%!v:lua.require('cmill.core.statusline').render()"

return M
