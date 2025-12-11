local M = {}

local function center_text(text)
    local width = vim.api.nvim_win_get_width(0)
    local padding = math.floor((width - #text) / 2)
    return string.rep(" ", padding) .. text
end

local function center_section(section)
    local longest = 0
    local width = vim.api.nvim_win_get_width(0)
    for _, text in ipairs(section) do
        longest = math.max(longest, #text)
    end
    local padding = math.floor((width - longest) / 2)
    for i, text in ipairs(section) do
        section[i] = string.rep(" ", padding) .. text
    end
    return section
end

M.bufopts = {
    modifiable = false,
    buftype = "nofile",
    bufhidden = "wipe",
    swapfile = false,
}

M.localopts = {
    number = false,
    relativenumber = false,
    cursorline = false,
    fillchars = "eob: ",
    statuscolumn = "",
}

M.keymaps = {
    { key = "f", cmd = "<cmd>FzfLua files<cr>", desc = "files" },
    { key = "r", cmd = "<cmd>FzfLua oldfiles<cr>", desc = "recents" },
    { key = "g", cmd = "<cmd>FzfLua live_grep<cr>", desc = "grep" },
    { key = "e", cmd = "<cmd>Explore<cr>", desc = "explorer" },
    { key = "s", cmd = "<cmd>Session select<cr>", desc = "session" },
    { key = "q", cmd = "<cmd>q!<cr>", desc = "quit" },
}

function M:setopts(bufnr)
    for opt, val in pairs(self.bufopts) do
        vim.api.nvim_set_option_value(opt, val, { buf = bufnr })
    end
    for opt, val in pairs(self.localopts) do
        vim.api.nvim_set_option_value(opt, val, { scope = "local" })
    end
end

function M:setmaps()
    for _, km in ipairs(self.keymaps) do
        vim.keymap.set("n", km.key, km.cmd, { buffer = true })
    end
end

function M.header()
    local version = vim.version()
    local nvim = ("NVIM v.%s.%s.%s"):format(version.major, version.minor, version.patch)
    local header = { center_text(nvim) }

    return header
end

function M.context()
    local cwd = vim.fn.getcwd():gsub(vim.env.HOME, "~")
    local context = ("%s"):format(cwd)
    return center_text(context)
end
function M.sessions()
    local has_some = "Sessions available"
    local has_none = "No sessions available"

    local exists = require("self.session.lib").session_exists()
    return exists and { center_text(has_some) } or { center_text(has_none) }
end

function M.center_content(content)
    local padded = {}
    for _, c in ipairs(content) do
        vim.list_extend(padded, c)
        padded[#padded + 1] = ""
    end
    local centered = {}
    local height = vim.api.nvim_win_get_height(0)
    local lnum_start = math.floor(height / 2) - #padded
    for _ = 1, lnum_start do
        table.insert(centered, "")
    end
    vim.list_extend(centered, padded)
    return centered
end

function M.show()
    if vim.fn.argc() ~= 0 then
        return
    end

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_set_current_buf(buf)
    vim.api.nvim_buf_delete(1, { force = true })
    local header = M.header()
    -- local sessions = M.sessions()
    local content = M.center_content({ header })

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
    M:setopts(buf)
    M:setmaps()
end

vim.api.nvim_create_autocmd("VimEnter", {
    callback = M.show,
    once = true,
})
