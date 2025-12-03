-- Highlight text on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.g.utils.augroup("highlight_yank"),
    desc = "highlight text on yank",
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Open buf to last location
vim.api.nvim_create_autocmd("BufReadPost", {
    group = vim.g.utils.augroup("last_loc"),
    desc = "go to last loc when opening buffer",
    callback = function(event)
        local exclude = { "gitcommit" }
        local buf = event.buf
        if
            vim.tbl_contains(exclude, vim.bo[buf].filetype)
            or vim.b[buf].lazyvim_last_loc
        then
            return
        end
        vim.b[buf].lazyvim_last_loc = true
        local mark = vim.api.nvim_buf_get_mark(buf, '"')
        local lcount = vim.api.nvim_buf_line_count(buf)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- Set term buf opts
vim.api.nvim_create_autocmd("TermOpen", {
    group = vim.g.utils.augroup("term"),
    desc = "set win opts when opening term buf",
    callback = function()
        vim.opt_local.spell = false
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.signcolumn = "no"
        vim.keymap.set("n", "q", "<cmd>bd!<cr>", { buffer = true })
    end,
})

-- Open scratch buf
vim.api.nvim_create_user_command("Scratch", function()
    vim.cmd("bel 10new")
    local buf = vim.api.nvim_get_current_buf()
    for name, value in pairs({
        filetype = "scratch",
        buftype = "nofile",
        bufhidden = "wipe",
        swapfile = false,
        modifiable = true,
    }) do
        vim.api.nvim_set_option_value(name, value, { buf = buf })
    end
end, { desc = "Open a scratch buffer", nargs = 0 })

local BufTracker = { _prev = nil }
local function notify_not_found(_)
    vim.notify("Previous buffer not set", vim.log.levels.INFO)
end

function BufTracker:prev(on_exists, on_not_found)
    -- BUG: if buffer is opened in split  and immediately closed, prev_buf
    -- state becomes invalid
    local bufnr
    if self._prev and vim.api.nvim_buf_is_valid(self._prev) then
        bufnr = self._prev
    elseif vim.fn.bufnr("#") >= 0 then
        bufnr = vim.fn.bufnr("#")
    else
        local not_found_callback = on_not_found or notify_not_found
        not_found_callback(self)
        return
    end

    if vim.bo.filetype ~= "netrw" then
        self:set_prev()
    end

    on_exists(bufnr)
end

function BufTracker:set_prev()
    self._prev = vim.api.nvim_get_current_buf()
end

-- stylua: ignore start
-- one-line functions to make parsing for selfhelp generation easier
vim.keymap.set("n", "<leader>pe", function() BufTracker:prev(function(bufnr) vim.api.nvim_set_current_buf(bufnr) end) end, { desc = "Buffer: previous buffer in current window" })
vim.keymap.set("n", "<leader>ps", function() BufTracker:prev(function(bufnr) vim.cmd("sbuffer " .. bufnr) end) end, { desc = "Buffer: previous buffer in hsplit" })
vim.keymap.set("n", "<leader>pv", function() BufTracker:prev(function(bufnr) vim.cmd("vert sbuffer " .. bufnr) end) end, { desc = "Buffer: previous buffer in vsplit" })
vim.keymap.set("n", "<leader>fe", function() BufTracker:prev(function(bufnr) if vim.bo.filetype == "netrw" then vim.api.nvim_set_current_buf(bufnr) else vim.cmd("Ex") end end, function(tracker) tracker:set_prev() vim.cmd("Ex") end) end, { desc = "Finder: Toggle netrw buffer" })
-- stylua: ignore end
