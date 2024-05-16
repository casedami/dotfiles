local M = {}

---@alias Sign {name:string, text:string, texthl:string, priority:number}

-- Returns a list of regular and extmark signs sorted by priority (low to high)
---@return Sign[]
---@param buf number
---@param lnum number
function M.get_signs(buf, lnum)
  -- Get regular signs
  ---@type Sign[]
  local signs = {}

  if vim.fn.has("nvim-0.10") == 0 then
    -- Only needed for Neovim <0.10
    -- Newer versions include legacy signs in nvim_buf_get_extmarks
    for _, sign in
      ipairs(vim.fn.sign_getplaced(buf, { group = "*", lnum = lnum })[1].signs)
    do
      local ret = vim.fn.sign_getdefined(sign.name)[1] --[[@as Sign]]
      if ret then
        ret.priority = sign.priority
        signs[#signs + 1] = ret
      end
    end
  end

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
    components[3] = is_file and M.icon(fold or right) or " "
  end

  local is_num = vim.wo[win].number
  local is_relnum = vim.wo[win].relativenumber
  if (is_num or is_relnum) and vim.v.virtnum == 0 then
    if vim.v.relnum == 0 then
      components[2] = is_num and "%l " or "%r " -- the current line
    else
      components[2] = is_relnum and "%r" or "%l" -- other lines
    end
    components[2] = "%=" .. components[2] .. " " -- right align
  end

  return table.concat(components, "")
end

local lsp_client = function()
  local bufnr = vim.api.nvim_get_current_buf()

  local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
  if next(clients) == nil then
    return ""
  else
    return "󱛀 "
  end
end

function M.statusline_components()
  local components = {
    nvim_icon = {
      function()
        return ""
      end,
      color = { fg = "#7da77e" },
    },
    sep = {
      function()
        return "|"
      end,
      color = { fg = "#7da77e" },
    },
    modes = {
      "mode",
      fmt = function(str)
        return str:sub(1, 3)
      end,
    },
    branch = {
      "branch",
      icon = "",
    },
    filename = {
      "filename",
      path = 3,
    },
    diagnostics = {
      "diagnostics",
      sections = { "error", "warn" },
      symbols = {
        error = "󰅖 ",
        warn = " ",
      },
    },
    progress = {
      "progress",
    },
    lsp = {
      lsp_client,
    },
    time = {
      "datetime",
      style = "%H:%M:%S",
    },
    date = {
      "datetime",
      style = "%Y-%m-%d",
      color = { fg = "#88888f" },
    },
    location = {
      "location",
    },
    tabs = {
      function()
        return vim.fn.tabpagenr()
      end,
      -- color = { fg = "#dbbc8a" },
      cond = function()
        return vim.api.nvim_eval("len(gettabinfo())") > 1
      end,
    },
    pomodoro = {
      require("cmill.core.pomodoro").statusline,
      color = { fg = "#559ba3", bg = "#1d1d1f" },
      separator = { left = "", right = "" },
      cond = function()
        return require("cmill.core.pomodoro").statusline() ~= "(inactive)"
      end,
    },
  }
  return components
end

function M.config()
  return require("telescope.builtin")["find_files"]({ cwd = vim.fn.stdpath("config") })
end

function M.lspicons()
  return {
    Namespace = "󰌗 ",
    Text = "󰉿 ",
    Method = "󰆧 ",
    Function = "󰆧 ",
    Constructor = " ",
    Field = "󰜢 ",
    Variable = "󰀫 ",
    Class = "󰠱 ",
    Interface = " ",
    Module = " ",
    Property = "󰜢 ",
    Unit = "󰑭 ",
    Value = "󰎠 ",
    Enum = " ",
    Keyword = "󰌋 ",
    Snippet = " ",
    Color = "󰏘 ",
    File = "󰈚 ",
    Reference = "󰈇 ",
    Folder = "󰉋 ",
    EnumMember = " ",
    Constant = "󰏿 ",
    Struct = "󰙅 ",
    Event = " ",
    Operator = "󰆕 ",
    TypeParameter = "󰊄 ",
    Table = " ",
    Object = "󰅩 ",
    Tag = " ",
    Array = "[] ",
    Boolean = " ",
    Number = " ",
    Null = "󰟢 ",
    String = "󰉿 ",
    Calendar = " ",
    Watch = "󰥔 ",
    Package = " ",
    Copilot = " ",
    Codeium = " ",
    TabNine = " ",
  }
end

return M
