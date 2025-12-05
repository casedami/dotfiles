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

local function prev_edit()
    BufTracker:prev(function(bufnr)
        vim.api.nvim_set_current_buf(bufnr)
    end)
end

local function prev_edit_sp()
    BufTracker:prev(function(bufnr)
        vim.cmd("sbuffer " .. bufnr)
    end)
end

local function prev_edit_vsp()
    BufTracker:prev(function(bufnr)
        vim.cmd("vert sbuffer " .. bufnr)
    end)
end

-- Open explorer in current buffer directory
local function explore_cbd()
    BufTracker:prev(function(bufnr)
        if vim.bo.filetype == "netrw" then
            vim.api.nvim_set_current_buf(bufnr)
        else
            vim.cmd("Ex")
        end
    end, function(tracker)
        tracker:set_prev()
        vim.cmd("Ex")
    end)
end

-- Open explorer in current working directory
local function explore_cwd()
    BufTracker:prev(function(bufnr)
        if vim.bo.filetype == "netrw" then
            vim.api.nvim_set_current_buf(bufnr)
        else
            vim.cmd("e .")
        end
    end, function(tracker)
        tracker:set_prev()
        vim.cmd("e .")
    end)
end

-- stylua: ignore start
vim.keymap.set("n", "<leader>pe", prev_edit, { desc = "Buffer: previous buffer in current window" })
vim.keymap.set("n", "<leader>ps", prev_edit_sp, { desc = "Buffer: previous buffer in hsplit" })
vim.keymap.set("n", "<leader>pv", prev_edit_vsp, { desc = "Buffer: previous buffer in vsplit" })

vim.keymap.set("n", "<leader>fe", explore_cbd, { desc = "Finder: Toggle netrw buffer" })
vim.keymap.set("n", "<leader>fE", explore_cwd, { desc = "Finder: Toggle netrw buffer in cwd" })
-- stylua: ignore end
