local M = {}
M.__index = M

---@alias Hunk { lc_old: number, lc_new: number, lnum_start: number, lnum_end: number, lines: string[] }

---@param lc_old number
---@param lnum_start number
---@param lc_new number
---@param lines string[]
---@return Hunk
function M:new(lc_old, lc_new, lnum_start, lines)
    local instance = {
        lc_old = lc_old,
        lc_new = lc_new,
        lnum_start = lnum_start,
        lnum_end = lnum_start + lc_new - 1,
        lines = lines,
    }
    setmetatable(instance, self)
    return instance
end

---@alias HunkType
---| "add"
---| "delete"
---| "change"

---@alias PartialHunk { lnum_start: number, lnum_end: number, type: HunkType }

---@return PartialHunk[]
function M:split()
    local partials = {}

    if self.lc_old == 0 and self.lc_new > 0 then
        partials[#partials + 1] =
            { lnum_start = self.lnum_start, lnum_end = self.lnum_end, type = "add" }
    elseif self.lc_old == 0 and self.lc_new == 0 then
        if self.lnum_start == 0 then
            partials[#partials + 1] = { lnum_start = 1, lnum_end = 1, type = "delete" }
        else
            partials[#partials + 1] = {
                lnum_start = self.lnum_start,
                lnum_end = self.lnum_start,
                type = "delete",
            }
        end
    else
        partials[#partials + 1] =
            { lnum_start = self.lnum_start, lnum_end = self.lnum_end, type = "change" }
    end
    return partials
end

---@alias HunkHeader { lc_old: number, lnum_start: number, lc_new: number }

---@param line string
---@return HunkHeader?
function M.try_parse_header(line)
    if not line:match("^@@ ") then
        return nil
    end

    local header = vim.tbl_map(function(s)
        return vim.split(s, ",")
    end, vim.split(line:sub(3), " "))

    local old, new = header[2], header[3]
    return {
        lc_old = tonumber(old[1]) or 0,
        lnum_start = tonumber(new[1]) or 0,
        lc_new = tonumber(new[2]) or 0,
    }
end

---@return Hunk[]
function M.from_diff(diff_lines)
    local hunks = {}

    local i = 1
    while i <= #diff_lines do
        local header = M.try_parse_diff_header(diff_lines[i])
        if header == nil then
            i = i + 1
        else
            i = i + 1 -- skip header
            local j = i
            while j <= #diff_lines and diff_lines[j]:match("^@@") do
                j = j + 1
            end
            local hunk = M:new(
                header.lc_old,
                header.lnum_start,
                header.lc_new,
                unpack(diff_lines, i, j - 1)
            )
            table.insert(hunks, hunk)
            i = j
        end
    end
    return hunks
end

return M
