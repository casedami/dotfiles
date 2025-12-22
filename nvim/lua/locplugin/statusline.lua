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
    location = vim.tbl_map(function(x)
        return Utils.hl_str("@variable", x)
    end, Icons.location),
}

---Returns a string of n spaces where n >= 1.
---@param n number?
---@return string
function M.pad(n)
    n = math.max(n or 1, 1)
    return string.rep(" ", n)
end

---Returns the current workspace diagnostics, if any.
---@return string?
function M.diagnostics()
    if not Utils.diagnostics_available() then
        return nil
    end

    local diag_count = vim.diagnostic.count()
    local err_count = diag_count[1] or 0
    local warn_count = diag_count[2] or 0

    if err_count > 0 or warn_count > 0 then
        return table.concat({
            M.icons.error,
            tostring(err_count),
            M.icons.warn,
            tostring(warn_count),
        }, " ")
    end

    return nil
end

---Returns git info via flamingo, if available.
---@return string?
function M.git()
    local root = vim.fs.root(0, ".git")
    if root == nil then
        return nil
    end
    if cache.git[root] ~= nil then
        return cache.git[root]
    end
    local branch = vim.fn.system("flamingo git")
    if #branch > 0 then
        local result = table.concat({
            M.icons.branch,
            Utils.hl_str("Type", branch),
        }, " ")
        cache.git[root] = result
        return result
    end
    return nil
end

---Returns the number of lines in the current buffer.
---@return string
function M.buflines()
    return M.icons.fileinfo .. " " .. vim.fn.line("$")
end

---Returns the location (percentage) of the cursor in the current buffer.
---@return string?
function M.bufloc()
    if vim.g.special_bufs[vim.bo.buftype] then
        return nil
    end

    local idx
    local lcount = vim.fn.line("$")
    if vim.fn.winheight(0) >= lcount then
        -- If window is taller than file, use last icon
        idx = #Icons.location
    else
        local loc = vim.fn.getpos(".")[2]
        idx = math.floor((loc - 1) / lcount * #Icons.location) + 1
    end

    return table.concat({
        M.icons.location[idx],
        Utils.hl_str("@variable", "%P"),
    }, " ")
end

---Returns highlighted buffer meta information: readonly | nomodifiable.
---@return string?
function M.bufmeta()
    local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
    local readonly = vim.api.nvim_get_option_value("readonly", { buf = bufnr })
            and M.icons.readonly
        or ""
    local nomod = vim.api.nvim_get_option_value("modifiable", { buf = bufnr }) and ""
        or M.icons.nomodifiable

    return (#readonly > 0 or #nomod > 0) and table.concat({ readonly, nomod }, "")
        or nil
end

---Returns the size of the current buffer in bytes.
---@return string?
function M.bufsize()
    local bytecount = tostring(vim.fn.getfsize(vim.fn.bufname()))
    if bytecount == "-1" then
        return nil
    end
    return M.icons.binary .. " " .. bytecount:gsub("(%d+)%d%d%d$", "%1k")
end

---Returns the showcmd output.
---@return string?
function M.showcmd()
    local out = vim.api.nvim_eval_statusline("%S", {}).str
    local excludes = {
        [":"] = true,
        ["j"] = true,
        ["k"] = true,
        ["zz"] = true,
    }
    if #out == 0 or excludes[out] then
        return nil
    end
    return Utils.hl_str(
        "Preproc",
        vim.g.icons.cmd .. vim.api.nvim_eval_statusline("%S", {}).str
    )
end

---Returns the path component (via flamingo).
---@return string
function M.path()
    local bufname = vim.api.nvim_buf_get_name(0)
    local bufnr = vim.api.nvim_get_current_buf()
    local formatted
    local cases = {
        terminal = "",
        nofile = "",
        help = "help pages",
    }
    if cases[vim.bo.buftype] then
        return cases[vim.bo.buftype]
    elseif cache.path[bufname] ~= nil then
        formatted = cache.path[bufname]
    elseif bufname == "" then
        return bufname
    else
        formatted = vim.fn.system("flamingo path -f " .. bufname)
        local head = vim.fn.fnamemodify(formatted, ":h")
        local tail = string.format(
            "%s %s",
            vim.fn.fnamemodify(formatted, ":t"),
            require("mini.icons").get("extension", vim.bo.filetype)
        )
        cache.path[bufname] = head .. "/" .. Utils.hl_str("TODO", tail)
    end

    local modified = vim.api.nvim_get_option_value("modified", { buf = bufnr })
            and M.icons.modified
        or ""
    return table.concat({
        formatted,
        modified,
    }, M.pad(1))
end

---Returns the Neovim prefix component.
---Note: if more than 1 tab exists, then shows the tab number instead.
---@return string
function M.prefix()
    local comp = Icons.neovim
    if vim.api.nvim_eval("len(gettabinfo())") > 1 then
        comp = tostring(vim.fn.tabpagenr())
    end
    return Utils.hl_str("@lsp.typemod.keyword.documentation", comp)
end

---Returns the current os_user.
---@return string
function M.user()
    return Utils.hl_str(
        "@lsp.typemod.keyword.documentation",
        vim.uv.os_get_passwd()["username"]
    )
end

---Returns the current venv, if one exists.
---@return string?
function M.venv()
    local venv = os.getenv("VIRTUAL_ENV")
    if venv then
        return table.concat({
            M.icons.venv,
            Utils.hl_str("@property", vim.fn.fnamemodify(venv, ":t")),
            M.pad(2),
        }, "")
    end
    return nil
end

---Global callback to build the statusline.
function RenderStatusLine()
    local function filter_nil(...)
        local result = {}
        local nargs = select("#", ...)
        for i = 1, nargs do
            local val = select(i, ...)
            if val ~= nil then
                result[#result + 1] = val
            end
        end
        return result
    end

    local left = filter_nil(
        M.pad(1),
        M.prefix(),
        M.user(),
        M.pad(1),
        M.venv(),
        M.git(),
        M.pad(1),
        M.path(),
        M.bufmeta(),
        M.showcmd()
    )
    local right = filter_nil(
        M.diagnostics(),
        M.pad(1),
        M.bufsize(),
        M.pad(1),
        M.buflines(),
        M.pad(1),
        M.bufloc(),
        M.pad(1)
    )
    return table.concat(left, M.pad(1)) .. M.sep .. table.concat(right, M.pad(1))
end

vim.o.statusline = "%!v:lua.RenderStatusLine()"
