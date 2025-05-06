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
        return table.concat({ spaces, in_str })
    end

    return table.concat({ in_str, spaces })
end

function M.hl_icons(icon_list)
    local hl_syms = {}

    for name, list in pairs(icon_list) do
        local val = nil
        if type(list[2]) == "table" then
            val = {}
            for i, icon in ipairs(list[2]) do
                val[i] = M.hl_str(list[1], icon)
            end
        else
            val = M.hl_str(list[1], list[2])
        end
        hl_syms[name] = val
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

    return table.concat(str_table)
end

function M.hl_str(hl, str)
    return "%#" .. hl .. "#" .. str .. "%*"
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
