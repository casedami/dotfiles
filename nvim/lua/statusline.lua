local Utils = vim.g.utils
local Icons = vim.g.icons

local cache = { path = {}, git = {} }
local M = { sep = "%=" }

M.icons = {
    binary = Utils.hl_str("DiagnosticHint", Icons.binary),
    branch = Utils.hl_str("Type", Icons.branch),
    error = Utils.hl_str("DiagnosticError", Icons.diag.error),
    fileinfo = Utils.hl_str("DiagnosticHint", Icons.hamburger),
    modified = Utils.hl_str("TODO", Icons.modified),
    nomodifiable = Utils.hl_str("DiagnosticWarn", Icons.lock),
    readonly = Utils.hl_str("DiagnosticHint", Icons.readonly),
    warn = Utils.hl_str("DiagnosticWarn", Icons.diag.warning),
    venv = Utils.hl_str("@property", Icons.venv),
    location = Utils.hl_tbl("@variable", Icons.location),
}

---Returns a string of n spaces.
---Note: If n is nil, returns a string with 1 space.
---@param n number?
---@return string
function M.pad(n)
    n = n or 1
    return string.rep(" ", n)
end

---Returns a highlighted diagnostics component.
---Note: if no diagnostics are available, then returns an empty string.
---@return string
function M.diagnostics()
    if not Utils.diagnostics_available() then
        return ""
    end

    local diag_count = vim.diagnostic.count()
    local err_count = diag_count[1] or 0
    local warn_count = diag_count[2] or 0

    if err_count > 0 or warn_count > 0 then
        local comp = table.concat({
            M.icons.error,
            tostring(err_count),
            M.icons.warn,
            tostring(warn_count),
        }, " ")
        return comp
    end

    return ""
end

---Returns the highlighted git component via flamingo, if available.
---@return string
function M.git()
    local root = vim.fs.root(0, ".git")
    if root == nil then
        return ""
    end
    if cache.git[root] ~= nil then
        return cache.git[root]
    end
    local branch = vim.fn.system("flamingo git")
    if #branch > 0 then
        local comp = table.concat({
            M.icons.branch,
            Utils.hl_str("Type", branch),
        }, " ")
        cache.git[root] = comp
        return comp
    end
    return ""
end

---Returns the number of lines in the current buffer.
---@return string
function M.flines()
    local nlines = vim.fn.line("$")
    return M.icons.fileinfo .. " " .. nlines
end

---Returns the location (percentage) of the cursor in the current buffer.
---@return string
function M.floc()
    if vim.g.special_bufs[vim.bo.buftype] then
        return ""
    end
    local nlines = vim.fn.line("$")

    local winheight = vim.fn.winheight(0)

    -- If window is taller than file, use last icon
    local idx
    if winheight >= nlines then
        idx = #Icons.location
    else
        local loc = vim.fn.getpos(".")[2]
        idx = math.floor((loc - 1) / nlines * #Icons.location) + 1
    end

    local comp = table.concat({
        M.icons.location[idx],
        Utils.hl_str("@variable", "%P"),
    }, " ")
    return comp
end

---Returns highlighted buffer meta information: readonly | nomodifiable.
---@return string
function M.fmeta()
    local buf_num = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
    local readonly = vim.api.nvim_get_option_value("readonly", { buf = buf_num })
            and M.icons.readonly
        or ""
    local nomod = vim.api.nvim_get_option_value("modifiable", { buf = buf_num }) and ""
        or M.icons.nomodifiable
    local comp = table.concat({
        readonly,
        nomod,
    }, "")
    return comp
end

---Returns the size of the current buffer in bytes.
---@return string
function M.fsize()
    local fsize = tostring(vim.fn.getfsize(vim.fn.bufname()))
    if fsize == "-1" then
        return ""
    end
    fsize = fsize:gsub("(%d+)%d%d%d$", "%1k")
    local comp = M.icons.binary .. " " .. fsize
    return comp
end

---Returns the showcmd output
function M.showcmd()
    local out = vim.api.nvim_eval_statusline("%S", {}).str
    local excludes = {
        [":"] = true,
        ["j"] = true,
        ["k"] = true,
        ["zz"] = true,
    }
    if #out == 0 or excludes[out] then
        return ""
    end
    return Utils.hl_str(
        "Preproc",
        vim.g.icons.cmd .. vim.api.nvim_eval_statusline("%S", {}).str
    )
end

---Returns the path component (via flamingo).
---@return string
function M.path()
    local fname = vim.api.nvim_buf_get_name(0)
    local bufnr = vim.api.nvim_get_current_buf()
    local formatted
    local cases = {
        terminal = "",
        nofile = "",
        help = "help pages",
    }
    if cases[vim.bo.buftype] then
        return cases[vim.bo.buftype]
    elseif cache.path[fname] ~= nil then
        formatted = cache.path[fname]
    elseif fname == "" then
        return fname
    else
        formatted = vim.fn.system("flamingo path -f " .. fname)
        local head = vim.fn.fnamemodify(formatted, ":h")
        local tail = string.format(
            "%s %s",
            vim.fn.fnamemodify(formatted, ":t"),
            require("mini.icons").get("extension", vim.bo.filetype)
        )
        cache.path[fname] = head .. "/" .. Utils.hl_str("TODO", tail)
    end

    local modified = vim.api.nvim_get_option_value("modified", { buf = bufnr })
            and M.icons.modified
        or ""
    local comp = table.concat({
        formatted,
        modified,
    }, M.pad(1))
    return comp
end

---Returns the Neovim prefix component.
---Note: if more than 1 tab exists, then shows the tab number instead.
---@return string
function M.prefix()
    local comp = Icons.neovim
    if vim.api.nvim_eval("len(gettabinfo())") > 1 then
        comp = vim.fn.tabpagenr()
    end
    return Utils.hl_str("@lsp.typemod.keyword.documentation", comp)
end

---Returns the current os_user.
---@return string
function M.user()
    local comp = Utils.hl_str(
        "@lsp.typemod.keyword.documentation",
        vim.uv.os_get_passwd()["username"]
    )

    return comp
end

---Returns the current venv, if one exists.
---@return string
function M.venv()
    local venv = os.getenv("VIRTUAL_ENV")
    if venv then
        local name = vim.fn.fnamemodify(venv, ":t")
        local comp = table.concat({
            M.icons.venv,
            Utils.hl_str("@property", name),
            M.pad(2),
        }, "")
        return comp
    end
    return ""
end

---Global callback to build the statusline.
function RenderStatusLine()
    local left = table.concat({
        M.pad(1),
        M.prefix(),
        M.user(),
        M.pad(1),
        M.venv(),
        M.git(),
        M.pad(1),
        M.path(),
        M.fmeta(),
        M.showcmd(),
    }, M.pad(1))

    local right = table.concat({
        M.diagnostics(),
        M.pad(1),
        M.fsize(),
        M.pad(1),
        M.flines(),
        M.pad(1),
        M.floc(),
        M.pad(1),
    }, M.pad(1))

    return table.concat({ left, right }, M.sep)
end

vim.o.statusline = "%!v:lua.RenderStatusLine()"
