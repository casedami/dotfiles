local M = {}

local function center_text(text)
    local width = vim.api.nvim_win_get_width(0)
    local padding = math.floor((width - #text) / 2)
    return string.rep(" ", padding) .. text
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
    { key = "s", cmd = "<cmd>SessionLoad<cr>", desc = "session" },
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
    local nvim = ("NEOVIM v.%s.%s.%s"):format(
        version.major,
        version.minor,
        version.patch
    )
    local cwd = vim.fn.getcwd():gsub(vim.env.HOME, "~")
    local context = ("%s"):format(cwd)

    local vpad = {}
    local height = vim.api.nvim_win_get_height(0)
    for _ = 1, math.floor(height / 4) do
        table.insert(vpad, "")
    end

    local header = {
        center_text(nvim),
        "",
        center_text(context),
    }

    local lines = {}
    vim.list_extend(lines, vpad)
    vim.list_extend(lines, header)

    return lines
end

function M.show()
    if vim.fn.argc() ~= 0 then
        return
    end

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_set_current_buf(buf)
    local header = M.header()

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, header)
    M:setopts(buf)
    M:setmaps()
end

vim.api.nvim_create_autocmd("VimEnter", {
    callback = M.show,
    once = true,
})
