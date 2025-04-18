local util = require("cmill.core.util")
local get_opt = vim.api.nvim_get_option_value

local M = {}

local status_parts = {
    buf_info = nil,
    diag = nil,
    git_info = nil,
    modifiable = nil,
    modified = nil,
    pad = " ",
    path = nil,
    readonly = nil,
    sep = "%=",
    trunc = "%<",
    venv = nil,
    fsize = nil,
}

local status_order = {
    "pad",
    "venv",
    "path",
    "mod",
    "readonly",
    "sep",
    "sep",
    "diag",
    "fileinfo",
    "fsize",
    "pad",
}

local icons = tools.ui.icons
local hl_ui_icons = util.hl_icons({
    ["binary"] = { "DiagnosticHint", icons["binary"] },
    ["branch"] = { "Type", icons["branch"] },
    ["error"] = { "DiagnosticError", icons["diag"] },
    ["fileinfo"] = { "DiagnosticHint", icons["hamburger"] },
    ["modified"] = { "TODO", icons["modified"] },
    ["nomodifiable"] = { "DiagnosticWarn", icons["lock"] },
    ["readonly"] = { "DiagnosticHint", icons["readonly"] },
    ["warn"] = { "DiagnosticWarn", icons["diag"] },
    ["location"] = { "@variable", icons["location"] },
})

---Create a string containing info for the current git branch
---@param root? string
---@param fname string
---@param icon_tbl table
---@return string|nil
local function path_info(root, fname, icon_tbl)
    if root == nil then
        return fname
    end
    local tail = vim.fn.fnamemodify(fname, ":t")
    local icon, hl = require("mini.icons").get("file", tail)
    icon = tail ~= "" and util.hl_str(hl, icon) or ""
    local tail_and_icon = table.concat({ tail, status_parts.pad, icon })

    if vim.bo.buftype == "help" then
        return tail_and_icon
    end

    local branch = tools.git_branch(root)
    local head = (vim.fn.fnamemodify(fname, ":h") .. "/"):gsub(
        "^/Users/caseymiller/",
        "~/"
    )

    local width = vim.api.nvim_win_get_width(0)
    local max_head_len = 15
    local max_repo_len = 10

    local repo_info = ""
    if branch then
        if #branch >= max_repo_len then
            branch = branch:gsub("^(%a%a%a%a%a%a%a%a%a%a)%a+", "%1" .. icons.ellipses)
        end
        repo_info = table.concat({
            icon_tbl["branch"],
            util.hl_str("Type", branch),
            status_parts.pad,
        }, " ")
    end

    if #head + #tail > max_head_len then
        local _, _, grandparent, parent = string.find(head, "(%a+)/(%a+)/$")
        if grandparent and grandparent ~= "~" and parent then
            head = table.concat({ icons.ellipses, grandparent, parent }, "/") .. "/"
        elseif parent and parent ~= "~" then
            head = head:gsub("(%a)%a*/", "%1/")
        end
    end

    head = width >= max_head_len + #repo_info + #head + #tail_and_icon and head or ""
    repo_info = width >= max_repo_len + #repo_info + #tail_and_icon and repo_info or ""
    return table.concat({
        repo_info,
        head,
        tail_and_icon,
    })
end

---@return string
local function diagnostics()
    if not tools.diagnostics_available() then
        return ""
    end

    local diag_count = vim.diagnostic.count()
    local err_count = diag_count[1] or 0
    local warn_count = diag_count[2] or 0

    return (err_count > 0 or warn_count > 0)
            and table.concat({
                hl_ui_icons["error"],
                " ",
                util.pad_str(tostring(err_count), 3, "left"),
                " ",
                hl_ui_icons["warn"],
                " ",
                util.pad_str(tostring(warn_count), 3, "left"),
                " ",
            })
        or ""
end

local function vlines()
    local raw_count = vim.fn.line(".") - vim.fn.line("v")
    raw_count = raw_count < 0 and raw_count - 1 or raw_count + 1
    return util.group_number(math.abs(raw_count), ",")
end

--- @return string word count
local function fileinfo(icon_tbl)
    local ft = get_opt("filetype", {})
    local lines = util.group_number(vim.api.nvim_buf_line_count(0), ",")

    -- MARK: text files
    if tools.text_ft[ft] then
        local wc_table = vim.fn.wordcount()
        if not wc_table.visual_words or not wc_table.visual_chars then
            -- MARK: normal mode
            return table.concat({
                icon_tbl.fileinfo,
                " ",
                lines,
                " lines  ",
                util.group_number(wc_table.words, ","),
                " words ",
            })
        else
            -- MARK: visual mode
            return table.concat({
                util.hl_str("DiagnosticInfo", "<>"),
                vlines(),
                "lines",
                status_parts.pad,
            }, " ")
        end
    -- MARK: special buffers (prompt, terminal, ...)
    elseif tools.special_bt[vim.bo.buftype] then
        return ""
    -- MARK: source files
    else
        local loc = vim.fn.getpos(".")[2]
        local idx = math.floor((loc - 1) / lines * #icons.location) + 1
        return table.concat({
            icon_tbl.binary .. " ",
            vim.fn.getfsize(vim.fn.bufname()),
            "bytes",
            status_parts.pad,
            icon_tbl.fileinfo .. " ",
            lines,
            "lines",
            status_parts.pad,
            icon_tbl.location[idx],
            util.hl_str("@variable", "%P"),
        }, " ")
    end
end

--- @return string|nil
local pyenv = function()
    local venv = os.getenv("VIRTUAL_ENV")
    if venv then
        local name = vim.fn.fnamemodify(venv, ":t")
        return util.hl_str("@property", name)
    end

    local conda = os.getenv("CONDA_DEFAULT_ENV")
    if conda then
        return util.hl_str("@property", conda)
    end

    return nil
end

--- Creates statusline
--- @return string statusline text to be displayed
M.render = function()
    local fname = vim.api.nvim_buf_get_name(0)
    local root = nil
    local cases = {
        terminal = "term",
        nofile = vim.bo.ft:gsub(".*snacks.*", "explorer"),
        prompt = vim.bo.ft:gsub(".*snacks.*", "explorer"),
    }
    if cases[vim.bo.buftype] then
        fname = cases[vim.bo.buftype]
    else
        root = tools.path_root(fname)
    end

    local buf_num = vim.api.nvim_win_get_buf(vim.g.statusline_winid)

    -- MARK: left
    status_parts["path"] = path_info(root, fname, hl_ui_icons)
    if not get_opt("modifiable", { buf = buf_num }) then
        status_parts["mod"] =
            table.concat({ status_parts.pad, hl_ui_icons["nomodifiable"] })
    elseif get_opt("modified", { buf = buf_num }) then
        status_parts["mod"] = hl_ui_icons["modified"]
    else
        status_parts["mod"] = " "
    end

    status_parts["readonly"] = get_opt("readonly", { buf = buf_num })
            and hl_ui_icons["readonly"]
        or ""

    -- MARK: middle
    if vim.bo.filetype == "python" then
        status_parts["venv"] = pyenv()
    end

    -- MARK: right
    status_parts["diag"] = diagnostics()
    status_parts["fileinfo"] = fileinfo(hl_ui_icons)

    return util.ordered_tbl_concat(status_order, status_parts)
end

vim.o.statusline = "%!v:lua.require('cmill.core.statusline').render()"

return M
