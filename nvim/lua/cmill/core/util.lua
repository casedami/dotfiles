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

---@return Sign?
---@param buf number
---@param lnum number
function M.get_mark(buf, lnum)
  local marks = vim.fn.getmarklist(buf)
  vim.list_extend(marks, vim.fn.getmarklist())
  for _, mark in ipairs(marks) do
    if mark.pos[1] == buf and mark.pos[2] == lnum and mark.mark:match("[a-zA-Z]") then
      return { text = mark.mark:sub(2), texthl = "DiagnosticInfo" }
    end
  end
end

---@param sign? Sign
---@param len? number
function M.icon(sign, len)
  sign = sign or {}
  len = len or 2
  local text = vim.fn.strcharpart(sign.text or "", 0, len) ---@type string
  text = text .. string.rep(" ", len - vim.fn.strchars(text))
  return sign.texthl and ("%#" .. sign.texthl .. "#" .. text .. "%*") or text
end

-- Build statuscoloumn of the form {diagnostics, marks}-linenumber-{gitsigns, folds}
function M.statuscolumn()
  local win = vim.g.statusline_winid
  local buf = vim.api.nvim_win_get_buf(win)
  local is_term = vim.bo[buf].buftype == "terminal"

  local components = { "", "", "" }

  if not is_term then
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
    -- Right: fold icon or git sign
    components[3] = M.icon(fold or right)
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

-- Returns icon if an lsp client is attached to the current buffer, otherwise an empty string
local lsp_client = function()
  local bufnr = vim.api.nvim_get_current_buf()

  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  if next(clients) == nil then
    return ""
  else
    return "󱛀 "
  end
end

-- Returns a table of lualine components with configs
function M.statusline_components()
  local components = {
    branch = {
      "branch",
      icon = "",
    },
    date = {
      "datetime",
      style = "%Y-%m-%d",
      color = { fg = "#88888f" },
    },
    diagnostics = {
      "diagnostics",
      sections = { "error", "warn" },
      symbols = {
        error = "󰅖",
        warn = "",
      },
    },
    diff = {
      "diff",
    },
    filename = {
      "filename",
      path = 3,
      fmt = function(str)
        local path = require("oil").get_current_dir() or ""
        local ftype = {
          TelescopePrompt = "Telescope",
          oil = path:gsub("^/Users/caseymiller", "~"),
          lazy = "Lazy",
          fugitive = "Git",
          dashboard = "Dashboard",
        }
        local btype = {
          terminal = "terminal",
          quickfix = "quickfix",
        }

        if vim.bo.filetype ~= "TelescopePrompt" and vim.bo.buftype == "prompt" then
          return ""
        else
          return ftype[vim.bo.filetype] or btype[vim.bo.buftype] or str
        end
      end,
    },
    location = {
      "location",
    },
    lsp = {
      lsp_client,
    },
    modes = {
      "mode",
      fmt = function(str)
        return str:sub(1, 3)
      end,
    },
    nvim_icon = {
      function()
        return ""
      end,
      color = function()
        local palette = require("neomodern.terminal").colors()
        return { fg = palette.green }
      end,
    },
    progress = {
      "progress",
    },
    tabs = {
      function()
        return vim.fn.tabpagenr()
      end,
      cond = function()
        return vim.api.nvim_eval("len(gettabinfo())") > 1
      end,
    },
    time = {
      "datetime",
      style = "%H:%M:%S",
    },
  }
  return components
end

function M.is_git_repo()
  local dir = vim.uv.cwd()
  local cmd = { "git", "-C", dir, "rev-parse", "--is-inside-work-tree" }
  local result = vim.system(cmd):wait()
  return result.code == 0
end

-- Opens telescope for searching .config files
function M.config()
  return require("telescope.builtin")["find_files"]({ cwd = vim.fn.stdpath("config") })
end

-- Opens a prompt for creating a new file or a new note if in ~/self/notes/
function M.new_file_prompt()
  local path = vim.fn.expand("%:p:h")
  local is_note = path:find("self/notes")

  if is_note then
    path = vim.fn.expand("~") .. "/self/notes/main/inbox"
  end

  vim.api.nvim_input(":e " .. path .. "/")
end

return M
