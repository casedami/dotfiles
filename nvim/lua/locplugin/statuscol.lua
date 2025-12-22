local ns_marks = vim.api.nvim_create_namespace("marksigns")

-- Show a-zA-Z marks to status column
vim.api.nvim_create_autocmd("CursorMoved", {
    group = vim.g.utils.augroup("marks"),
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

local GitSigns = {}
local ns = vim.api.nvim_create_namespace("gitsigns")
local refcache = {}

vim.api.nvim_set_hl(0, "GitSignsAdd", { link = "DiagnosticSignOk" })
vim.api.nvim_set_hl(0, "GitSignsChange", { link = "DiagnosticHint" })
vim.api.nvim_set_hl(0, "GitSignsDelete", { link = "DiagnosticError" })

function GitSigns.get_buftext(bufnr)
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local text = table.concat(lines, "\n") .. "\n"
    return text
end

function GitSigns.get_reftext(bufnr, callback)
    local path = vim.api.nvim_buf_get_name(bufnr)
    if path == "" then
        return callback(nil)
    elseif refcache[bufnr] ~= nil then
        return callback(refcache[bufnr])
    end

    local head = vim.fn.fnamemodify(path, ":h")
    local tail = vim.fn.fnamemodify(path, ":t")

    vim.system(
        { "git", "show", ":0:./" .. tail },
        { cwd = head, text = true },
        function(result)
            vim.schedule(function()
                if result.code ~= 0 then
                    return callback(nil)
                end
                callback(result.stdout:gsub("\r\n", "\n"))
            end)
        end
    )
end

function GitSigns.apply_signs(bufnr, diff)
    for _, hunk in ipairs(diff) do
        ---@diagnostic disable-next-line: deprecated
        local _, count_a, start_b, count_b = unpack(hunk)

        if count_b == 0 then
            -- Deleted
            local line = math.max(0, start_b - 1)
            vim.api.nvim_buf_set_extmark(bufnr, ns, line, 0, {
                sign_text = vim.g.icons.diff.delete,
                sign_hl_group = "GitSignsDelete",
            })
        elseif count_a == 0 then
            -- Added
            for i = 0, count_b - 1 do
                vim.api.nvim_buf_set_extmark(bufnr, ns, start_b - 1 + i, 0, {
                    sign_text = vim.g.icons.diff.add,
                    sign_hl_group = "GitSignsAdd",
                })
            end
        else
            -- Changed
            for i = 0, count_b - 1 do
                vim.api.nvim_buf_set_extmark(bufnr, ns, start_b - 1 + i, 0, {
                    sign_text = vim.g.icons.diff.change,
                    sign_hl_group = "GitSignsChange",
                })
            end
        end
    end
end

function GitSigns.update()
    local vimdiff_opts = {
        result_type = "indices",
        ctxlen = 0,
        interhunkctxlen = 0,
        algorithm = "minimal",
        indent_heuristic = false,
        linematch = 0,
    }

    local bufnr = vim.api.nvim_get_current_buf()
    if #vim.bo[bufnr].buftype > 0 then
        return
    end

    local buftext = GitSigns.get_buftext(bufnr)
    vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

    GitSigns.get_reftext(bufnr, function(reftext)
        refcache[bufnr] = reftext
        if not reftext then
            return
        end

        local diff = vim.text.diff(reftext, buftext, vimdiff_opts)
        GitSigns.apply_signs(bufnr, diff)
    end)
end

vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
    callback = GitSigns.update,
})
