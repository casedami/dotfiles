local ns_marks = vim.api.nvim_create_namespace("marksigns")

local function augroup(name)
    return vim.api.nvim_create_augroup("__" .. name, { clear = true })
end

-- Show a-zA-Z marks to status column
vim.api.nvim_create_autocmd("CursorMoved", {
    group = augroup("marks"),
    desc = "add marks to signcolumn",
    callback = function()
        local buf = vim.api.nvim_win_get_buf(0)
        local marks = vim.fn.getmarklist(buf)
        vim.api.nvim_buf_clear_namespace(buf, ns_marks, 0, -1)
        vim.list_extend(marks, vim.fn.getmarklist())
        for _, mark in ipairs(marks) do
            if mark.pos[1] == buf and mark.mark:match("[a-zA-Z]") then
                local lnum = mark.pos[2]
                vim.api.nvim_buf_set_extmark(buf, ns_marks, lnum - 1, 0, {
                    id = lnum,
                    sign_text = mark.mark:sub(2),
                    priority = 1,
                    sign_hl_group = "DiagnosticInfo",
                    cursorline_hl_group = "DiagnosticInfo",
                })
            end
        end
    end,
})
