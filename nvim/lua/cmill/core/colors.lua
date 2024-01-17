local M = {}

local colors = {
  dark = {
    black = "#000000",
    bg = "#1e2326",
    fg = "#4F5B58",
    fg_hi = "#859289",
    nvim_bg = "#08090a",
    nvim_fg = "#A7C080",
    git_bg = "#272e33",
    git_fg = "#DBBC7F",
    mode_nor = "#9DA9A0",
    mode_com = "#E69875",
    mode_ins = "#DBBC7F",
    mode_vis = "#D699B6",
    mode_rep = "#7FBBB3",
  },
  light = {
    black = "#000000",
    bg = "#E5DFC5",
    fg = "#829181",
    fg_hi = "#5C6A72",
    nvim_bg = "#939F91",
    nvim_fg = "#000000",
    git_bg = "#E5DFC5",
    git_fg = "#DFA000",
    mode_nor = "#D3C6AA",
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
  bg0 = "#161a1c",
  bg1 = "#1e2326",
  bg2 = "#272e33",
  fg = "#baae97",
  float = "#0c0e0f",
  orange = "#e69875",
  blue = "#7fbbb3",
  border = "#4f5858",
  line = "#101314",
  todo_red = "#f85552",
  todo_blue = "#3a94c5",
  todo_orange = "#f57d26",
  todo_yellow = "#dfa000",
  todo_aqua = "#35a77c",
  todo_purple = "#df69ba",
}

return M
