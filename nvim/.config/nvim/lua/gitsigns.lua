local ns = vim.api.nvim_create_namespace("gitsigns")

local hl = {
    add = "DiagnosticSignOk",
    delete = "DiagnosticError",
    change = "DiagnosticHint",
}

---@alias HunkType
---| "add"
---| "delete
---| "change"

---@alias Sign { icon: string, hl: string, lnum: number }
---@alias HunkDiff { start: number, count: number, lines: table }
---@alias HunkHead string

---@class Hunk
---@field removed HunkDiff
---@field added HunkDiff
---@field head HunkHead
---@field type HunkType

---@param old_start number
---@param old_count number
---@param new_start number
---@param new_count number
---@return Hunk
local function create_hunk(old_start, old_count, new_start, new_count)
    return {
        removed = { start = old_start, count = old_count, lines = {} },
        added = { start = new_start, count = new_count, lines = {} },
        head = ("@@ -%d%s +%d%s @@"):format(
            old_start,
            old_count > 0 and "," .. old_count or "",
            new_start,
            new_count > 0 and "," .. new_count or ""
        ),
        type = new_count == 0 and "delete" or old_count == 0 and "add" or "change",
    }
end

---@param line string
---@return Hunk?
local function parse_diff_line(line)
    if not line:match("^@@ ") then
        return nil
    end

    local header = vim.tbl_map(function(s)
        return vim.split(s, ",")
    end, vim.split(line:sub(3), " "))

    local pre, curr = header[2], header[3]
    local hunk = create_hunk(
        tonumber(pre[1]) or 1,
        tonumber(pre[2]) or 1,
        tonumber(curr[1]) or 1,
        tonumber(curr[2]) or 1
    )

    return hunk
end

---@param hunk Hunk
---@return Sign[]
local function build_signs(hunk)
    local start, added, removed = hunk.added.start, hunk.added.count, hunk.removed.count

    if hunk.type == "delete" and start == 0 then
        if hunk.removed.start <= 1 then
            -- topdelete signs get placed one row lower
            return { { type = "topdelete", count = removed, lnum = 1 } }
        else
            return {}
        end
    end

    local signs = {}

    for lnum = start, start + added do
        signs[#signs + 1] = {
            icon = vim.g.icons.diff[hunk.type],
            hl = hl[hunk.type],
            lnum = lnum,
        }
    end

    if hunk.type == "change" and added > removed then
        for lnum = start, start + added do
            signs[#signs + 1] = {
                icon = vim.g.icons.diff["add"],
                hl = hl["add"],
                lnum = lnum,
            }
        end
    end

    return signs
end

---@param bufnr number
---@return [Sign[]]
local function get(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    local fpath = vim.api.nvim_buf_get_name(bufnr)

    if fpath == "" then
        return {}
    end

    local result = vim.system(
        { "git", "diff", "--unified=0", "HEAD", fpath },
        { text = true }
    )
        :wait()

    if result.code ~= 0 then
        return {}
    end

    local signs = {}
    for line in result.stdout:gmatch("[^\r\n]+") do
        local hunk = parse_diff_line(line)
        if hunk ~= nil then
            signs[#signs + 1] = build_signs(hunk)
        end
    end

    return signs
end

local function update()
    local bufnr = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
    local hunks = get(bufnr)

    for _, hunk in ipairs(hunks) do
        for _, s in ipairs(hunk) do
            if s ~= nil then
                vim.api.nvim_buf_set_extmark(bufnr, ns, s.lnum - 1, 0, {
                    sign_text = s.icon,
                    sign_hl_group = s.hl,
                })
            end
        end
    end
end

vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
    callback = update,
})
