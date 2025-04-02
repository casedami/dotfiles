local M = {}

---@package
---@return boolean
function M.cwd_is_git_repo()
    local cmd = { "git", "rev-parse", "--is-inside-git-dir" }
    local result = vim.system(cmd):wait()
    return result.code == 0
end

---@package
---@return boolean
function M.git_has_local_changes()
    local cmd = { "git", "status", "--porcelain" }
    local result = vim.system(cmd):wait()
    return result.stdout and #result.stdout > 0
end

function M.show_diff()
    return M.cwd_is_git_repo() and M.git_has_local_changes()
end

---Convenient new file prompt expansion for startup screen
---@return nil
function M.new_file_prompt()
    local inp = vim.fn.input("Name: ")
    vim.cmd(("New %s"):format(inp))
end

function M.pad_str(in_str, width, align)
    local num_spaces = width - #in_str
    if num_spaces < 1 then
        num_spaces = 1
    end

    local spaces = string.rep(" ", num_spaces)

    if align == "left" then
        return table.concat({ in_str, spaces })
    end

    return table.concat({ spaces, in_str })
end

function M.hl_icons(icon_list)
    local hl_syms = {}

    for name, list in pairs(icon_list) do
        hl_syms[name] = M.hl_str(list[1], list[2])
    end

    return hl_syms
end

function M.ordered_tbl_concat(order_tbl, stl_part_tbl)
    local str_table = {}
    local part = nil

    for _, val in ipairs(order_tbl) do
        part = stl_part_tbl[val]
        if part then
            table.insert(str_table, part)
        end
    end

    return table.concat(str_table, " ")
end

function M.hl_str(hl, str)
    return "%#" .. hl .. "#" .. str .. "%*"
end

---Convert a hex color to an rgb color
---@param hex string
---@return number
---@return number
---@return number
local function hex_to_rgb(hex)
    if hex == nil then
        hex = "#000000"
    end
    return tonumber(hex:sub(2, 3), 16),
        tonumber(hex:sub(4, 5), 16),
        tonumber(hex:sub(6), 16)
end

---Shade Color generate
---@param hex string hex color
---@param percent number
---@return string
function M.tint(hex, percent)
    local r, g, b = hex_to_rgb(hex)

    -- If any of the colors are missing return "NONE" i.e. no highlight
    if not r or not g or not b then
        return "NONE"
    end

    r = math.floor(tonumber(r * (100 + percent) / 100) or 0)
    g = math.floor(tonumber(g * (100 + percent) / 100) or 0)
    b = math.floor(tonumber(b * (100 + percent) / 100) or 0)
    r, g, b = r < 255 and r or 255, g < 255 and g or 255, b < 255 and b or 255

    return "#" .. string.format("%02x%02x%02x", r, g, b)
end

---Get a hl group's rgb
---Note: Always gets linked colors
---@param opts table
---@param ns_id integer?
---@return table
function M.get_hl_hex(opts, ns_id)
    opts, ns_id = opts or {}, ns_id or 0
    assert(opts.name or opts.id, "Error: must have hl group name or ID!")
    opts.link = true

    local hl = vim.api.nvim_get_hl(ns_id, opts)

    return {
        fg = hl.fg and ("#%06x"):format(hl.fg),
        bg = hl.bg and ("#%06x"):format(hl.bg),
    }
end

function M.group_number(num, sep)
    if num < 999 then
        return tostring(num)
    else
        num = tostring(num)
        return num:reverse():gsub("(%d%d%d)", "%1" .. sep):reverse():gsub("^,", "")
    end
end

return M
