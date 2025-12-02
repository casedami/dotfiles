local M = {}
local ns = vim.api.nvim_create_namespace("gitsigns")
local refcache = {}

vim.api.nvim_set_hl(0, "GitSignsAdd", { link = "DiagnosticSignOk" })
vim.api.nvim_set_hl(0, "GitSignsChange", { link = "DiagnosticHint" })
vim.api.nvim_set_hl(0, "GitSignsDelete", { link = "DiagnosticError" })

function M.get_buftext(bufnr)
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local text = table.concat(lines, "\n") .. "\n"
    return text
end

function M.get_reftext(bufnr, callback)
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

function M.apply_signs(bufnr, diff)
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

function M.update()
    local vimdiff_opts = {
        result_type = "indices",
        ctxlen = 0,
        interhunkctxlen = 0,
        algorithm = "minimal",
        indent_heuristic = false,
        linematch = 0,
    }

    local bufnr = vim.api.nvim_get_current_buf()
    local buftext = M.get_buftext(bufnr)
    vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

    M.get_reftext(bufnr, function(reftext)
        refcache[bufnr] = reftext
        if not reftext then
            return
        end

        local diff = vim.diff(reftext, buftext, vimdiff_opts)
        M.apply_signs(bufnr, diff)
    end)
end

vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
    callback = M.update,
})
