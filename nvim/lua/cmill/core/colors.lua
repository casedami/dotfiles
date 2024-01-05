local M = {}

local colors = {
  dark = {
    dim = "#08090a",
    bg = "#1e2326",
    component = "#374145",
    segment = "#272e33",
    fg = "#4F5B58",
    fg_hi = "#859289",
    yellow = "#DBBC7F",
    green = "#A7C080",
    mode_nor = "#9DA9A0",
    mode_com = "#E69875",
    mode_ins = "#DBBC7F",
    mode_vis = "#D699B6",
    mode_rep = "#7FBBB3",
  },
  light = {
    bg = "#E5DFC5",
    fg = "#829181",
    fg_hi = "#5C6A72",
    mode_nor = "#A6BOAO",
    mode_com = "#F57D26",
    mode_ins = "#DFA000",
    mode_vis = "#DF69BA",
    mode_rep = "#35A77C",
  },
}

M.statusline = function()
  local background = vim.o.background
  return colors[background]
end

M.highlights = {
  fg = "#9DA9A0",
  fg_hi = "#272Е33",
  bg0 = "#161a1c",
  bg1 = "#1e2326",
  bg2 = "#272e33",
  float = "#0c0e0f",
  orange = "#e69875",
  blue = "#7fbbb3",
  border = "#4f5858",
  line = "#101314",
}

return M
