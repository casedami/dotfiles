local M = {}

function M.get_signs(buf, lnum)
  -- Get regular signs
  local signs = vim.tbl_map(function(sign)
    local ret = vim.fn.sign_getdefined(sign.name)[1]
    ret.priority = sign.priority
    return ret
  end, vim.fn.sign_getplaced(buf, { group = "*", lnum = lnum })[1].signs)

  -- Get extmark signs
  local extmarks = vim.api.nvim_buf_get_extmarks(
    buf,
    -1,
    { lnum - 1, 0 },
    { lnum - 1, -1 },
    { details = true, type = "sign" }
  )
  for _, extmark in pairs(extmarks) do
    signs[#signs + 1] = {
      name = extmark[4].sign_hl_group or "",
      text = extmark[4].sign_text,
      texthl = extmark[4].sign_hl_group,
      priority = extmark[4].priority,
    }
  end

  -- Sort by priority
  table.sort(signs, function(a, b)
    return (a.priority or 0) < (b.priority or 0)
  end)

  return signs
end

function M.get_mark(buf, lnum)
  local marks = vim.fn.getmarklist(buf)
  vim.list_extend(marks, vim.fn.getmarklist())
  for _, mark in ipairs(marks) do
    if mark.pos[1] == buf and mark.pos[2] == lnum and mark.mark:match("[a-zA-Z]") then
      return { text = mark.mark:sub(2), texthl = "DiagnosticInfo" }
    end
  end
end

function M.icon(sign, len)
  sign = sign or {}
  len = len or 2
  local text = vim.fn.strcharpart(sign.text or "", 0, len) ---@type string
  text = text .. string.rep(" ", len - vim.fn.strchars(text))
  return sign.texthl and ("%#" .. sign.texthl .. "#" .. text .. "%*") or text
end

-- build status column
function M.statuscolumn()
  local win = vim.g.statusline_winid
  local buf = vim.api.nvim_win_get_buf(win)
  local is_file = vim.bo[buf].buftype == ""
  local show_signs = vim.wo[win].signcolumn ~= "no"

  local components = { "", "", "" }

  if show_signs then
    local left, right, fold
    for _, s in ipairs(M.get_signs(buf, vim.v.lnum)) do
      if s.name and s.name:find("GitSign") then
        right = s
      else
        left = s
      end
    end
    if vim.v.virtnum ~= 0 then
      left = nil
    end
    vim.api.nvim_win_call(win, function()
      if vim.fn.foldclosed(vim.v.lnum) >= 0 then
        fold = { text = vim.opt.fillchars:get().foldclose or "", texthl = "Folded" }
      end
    end)
    -- Left: mark or non-git sign
    components[1] = " " .. M.icon(M.get_mark(buf, vim.v.lnum) or left)
    -- Right: fold icon or git sign (only if file)
    components[3] = is_file and M.icon(fold or right) or ""
  end

  local is_num = vim.wo[win].number
  local is_relnum = vim.wo[win].relativenumber
  if (is_num or is_relnum) and vim.v.virtnum == 0 then
    if vim.v.relnum == 0 then
      components[2] = is_num and "%l  " or "%r  " -- the current line
    else
      components[2] = is_relnum and "%r" or "%l" -- other lines
    end
    components[2] = "%=" .. components[2] .. " " -- right align
  end

  return table.concat(components, "")
end

function M.statusline_theme()
  local colors = require("cmill.core.colors").statusline()
  local theme = {
    normal = {
      a = { bg = colors.component, fg = colors.mode_nor, gui = "bold" },
      b = { bg = colors.bg, fg = colors.fg },
      c = { bg = colors.bg, fg = colors.fg },
    },
    insert = {
      a = { bg = colors.component, fg = colors.mode_ins },
    },
    visual = {
      a = { bg = colors.component, fg = colors.mode_vis },
    },
    replace = {
      a = { bg = colors.component, fg = colors.mode_rep },
    },
    command = {
      a = { bg = colors.component, fg = colors.mode_com },
    },
  }
  return theme
end

function M.statusline_components()
  local colors = require("cmill.core.colors").statusline()
  local components = {
    modes = {
      "mode",
      fmt = function(str)
        return str:sub(1, 3)
      end,
      separator = { left = "", right = "" },
    },
    nvim_icon = {
      function()
        return ""
      end,
      color = { bg = colors.dim, fg = colors.green },
      separator = { right = "" },
    },
    spacer = {
      function()
        return " "
      end,
      color = { bg = colors.bg, fg = colors.bg },
    },
    branch = {
      "branch",
      icon = "",
      color = { bg = colors.component, fg = colors.yellow },
      separator = { left = "", right = "" },
    },
    diff = {
      "diff",
      color = { bg = colors.segment, fg = colors.fg },
      colored = false,
      separator = { right = "" },
    },
    filename = {
      "filename",
      path = 3,
      symbols = {
        modified = "*",
        newfile = "[NEW]",
      },
      separator = { left = "", right = "" },
      color = { bg = colors.component, fg = colors.mode_nor },
    },
    filetype = {
      "filetype",
      color = { bg = colors.segment, fg = colors.fg },
      colored = false,
      icon_only = true,
      separator = { left = "", right = "" },
    },
    diagnostics = {
      "diagnostics",
      symbols = {
        error = " ",
        warn = "󰹆 ",
        hint = "󰌵 ",
        info = "󰙎 ",
      },
    },
    progress = {
      "progress",
    },
    location = {
      "location",
    },
    tabs = {
      "tabs",
      show_modified_status = false,
      mode = 0,
      tabs_color = {
        active = "lualine_a_insert",
        inactive = "lualine_b_normal",
      },
      cond = function()
        return vim.api.nvim_eval("len(gettabinfo())") > 1
      end,
    },
  }
  return components
end

return M
