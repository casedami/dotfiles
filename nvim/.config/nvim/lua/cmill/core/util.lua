local M = {}

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
    local icons = {}

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
        icons[name] = val
    end

    return icons
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
