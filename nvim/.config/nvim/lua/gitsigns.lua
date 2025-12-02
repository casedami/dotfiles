local ns = vim.api.nvim_create_namespace("gitsigns")
local Hunk = require("hunks")

local hl = {
    add = "DiagnosticSignOk",
    delete = "DiagnosticError",
    change = "DiagnosticHint",
}

local function update()
    local bufnr = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
    local fpath = vim.api.nvim_buf_get_name(bufnr)

    if fpath == "" then
        return
    end

    local result = vim.system(
        { "git", "diff", "--unified=0", "HEAD", fpath },
        { text = true }
    )
        :wait()

    if result.code ~= 0 then
        return
    end

    local lines = vim.split(result.stdout, "\n", { plain = true })
    local hunks = Hunk.from_diff(lines)

    local partials = {}
    for _, hunk in pairs(hunks) do
        vim.list_extend(partials, hunk:split())
    end

    for _, p in ipairs(partials) do
        for lnum = p.lnum_start, p.lnum_end do
            vim.api.nvim_buf_set_extmark(bufnr, ns, lnum, 0, {
                sign_text = vim.g.icons.diff[p.type],
                sign_hl_group = hl[p.type],
            })
        end
    end
end

-- vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
--     callback = update,
-- })
vim.api.nvim_create_autocmd({ "BufEnter" }, {
    callback = update,
})
