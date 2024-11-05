local M = {}
local culhl_cache = {}

---Creates a cursorline highlight group for signs by merging the signs highlight group
---and the CursorLineSign highlight group
---@param hlgroup string sign highlight group
---@return string
local function create_cul_hl(hlgroup)
  local newhl = {}
  local signhl = vim.api.nvim_get_hl(0, { name = hlgroup, link = false })
  if signhl then
    for k, v in pairs(signhl) do
      newhl[k] = v
    end
  end
  local culhl = vim.api.nvim_get_hl(0, { name = "CursorLineSign", link = false })
  if culhl then
    for k, v in pairs(culhl) do
      newhl[k] = v
    end
  end
  newhl["bold"] = true
  local merged = hlgroup .. "Cul"
  vim.api.nvim_set_hl(0, merged, newhl)
  culhl_cache[hlgroup] = merged
  return merged
end

---@alias Sign { name:string, text:string, texthl:string, priority:number, culhl:string }

---Returns a list of regular and extmark signs sorted by priority (low to high)
---@param buf number
---@param lnum number
---@return Sign[]
function M.get_signs(buf, lnum)
  ---@type Sign[]
  local signs = {}

  local extmarks = vim.api.nvim_buf_get_extmarks(
    buf,
    -1,
    { lnum - 1, 0 },
    { lnum - 1, -1 },
    { details = true, type = "sign" }
  )
  for _, extmark in pairs(extmarks) do
    local hlgroup = extmark[4].sign_hl_group or ""
    local culhl = nil
    if hlgroup then
      culhl = culhl_cache[hlgroup] or create_cul_hl(hlgroup)
    end
    signs[#signs + 1] = {
      name = hlgroup,
      text = extmark[4].sign_text,
      texthl = extmark[4].sign_hl_group,
      priority = extmark[4].priority,
      culhl = culhl or "CursorLineSign",
    }
  end

  table.sort(signs, function(a, b)
    return (a.priority or 0) < (b.priority or 0)
  end)

  return signs
end

---Returns user-set marks given a buffer and a line number
---@param buf number
---@param lnum number
---@return Sign?
function M.get_mark(buf, lnum)
  local marks = vim.fn.getmarklist(buf)
  vim.list_extend(marks, vim.fn.getmarklist())
  for _, mark in ipairs(marks) do
    if mark.pos[1] == buf and mark.pos[2] == lnum and mark.mark:match("[a-zA-Z]") then
      return {
        text = mark.mark:sub(2),
        texthl = "DiagnosticInfo",
        culhl = create_cul_hl("DiagnosticInfo"),
      }
    end
  end
end

---@param sign? Sign
---@param cul? boolean
---@return string icon
function M.icon(sign, cul)
  sign = sign or {}
  local len = 2
  local text = vim.fn.strcharpart(sign.text or "", 0, len) ---@type string
  text = text .. string.rep(" ", len - vim.fn.strchars(text))
  if cul then
    return sign.culhl and ("%#" .. sign.culhl .. "#" .. text .. "%*") or text
  else
    return sign.texthl and ("%#" .. sign.texthl .. "#" .. text .. "%*") or text
  end
end

function M.char_on_pos(pos)
  pos = pos or vim.fn.getpos(".")
  return tostring(vim.fn.getline(pos[1])):sub(pos[2], pos[2])
end

function M.char_byte_count(s, i)
  if not s or s == "" then
    return 1
  end

  local char = string.byte(s, i or 1)

  -- Get byte count of unicode character (RFC 3629)
  if char > 0 and char <= 127 then
    return 1
  elseif char >= 194 and char <= 223 then
    return 2
  elseif char >= 224 and char <= 239 then
    return 3
  elseif char >= 240 and char <= 244 then
    return 4
  end
end

function M.get_visual_range()
  local sr, sc = unpack(vim.fn.getpos("v"), 2, 3)
  local er, ec = unpack(vim.fn.getpos("."), 2, 3)

  -- To correct work with non-single byte chars
  local byte_c = M.char_byte_count(M.char_on_pos({ er, ec }))
  ec = ec + (byte_c - 1)

  local range = {}

  if sr == er then
    local cols = sc >= ec and { ec, sc } or { sc, ec }
    range = { sr, cols[1] - 1, er, cols[2] }
  elseif sr > er then
    range = { er, ec - 1, sr, sc }
  else
    range = { sr, sc - 1, er, ec }
  end

  return range
end

function M.hi_vis_range(is_cul)
  local hi = require("neomodern.palette")[vim.g.neomodern_config.theme].alt
  local visrangenr = { fg = hi }
  if is_cul then
    local bg = vim.api.nvim_get_hl(0, { name = "CursorLineSign", link = false }).bg
    visrangenr["bg"] = bg
    vim.api.nvim_set_hl(0, "VisualRangeNrCul", visrangenr)
    culhl_cache["VisualRangeNrCul"] = visrangenr
  else
    vim.api.nvim_set_hl(0, "VisualRangeNr", visrangenr)
    culhl_cache["VisualRangeNr"] = visrangenr
  end
end

function M.is_selected(is_cul)
  local v_hl = ""
  local mode = vim.fn.strtrans(vim.fn.mode()):lower():gsub("%W", "")
  if mode == "v" then
    local v_range = M.get_visual_range()
    local is_in_range = vim.v.lnum >= v_range[1] and vim.v.lnum <= v_range[3]
    if is_cul then
      if culhl_cache["VisualRangeNrCul"] == nil then
        M.hi_vis_range(is_cul)
      end
      v_hl = is_in_range and "%#VisualRangeNrCul#" or ""
    else
      if culhl_cache["VisualRangeNr"] == nil then
        M.hi_vis_range()
      end
      v_hl = is_in_range and "%#VisualRangeNr#" or ""
    end
  end
  return v_hl
end

---Builds and returns a status column of the form:
---[<diagnostics>, <marks>] [<linenr>] [<fold>, <gitsigns>]
---@return string
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
    local is_cul = vim.v.relnum == 0
    -- Left: mark or non-git sign
    components[1] = " " .. M.icon(M.get_mark(buf, vim.v.lnum) or left, is_cul)
    -- Right: fold icon or git sign
    components[3] = M.icon(fold or right, is_cul)
  end

  local is_num = vim.wo[win].number
  local is_relnum = vim.wo[win].relativenumber

  if (is_num or is_relnum) and vim.v.virtnum == 0 then
    if vim.v.relnum == 0 then
      local num = is_num and "%l " or "%r " -- the current line
      components[2] = M.is_selected(true) .. num
    else
      local num = is_relnum and "%r" or "%l" -- other lines
      components[2] = M.is_selected() .. num
    end
    components[2] = "%=" .. components[2] .. " " -- right align
  end

  return table.concat(components, "")
end

local lsp_client = function()
  local bufnr = vim.api.nvim_get_current_buf()

  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  if next(clients) == nil then
    return ""
  else
    return clients
  end
end

---Opts for lualine statusline components
---@return table
function M.statusline_components()
  local components = {
    git_branch = {
      "branch",
      icon = "",
    },
    date = {
      "datetime",
      style = "%Y-%m-%d",
      color = { fg = "#88888f" },
    },
    errs = {
      "diagnostics",
      sections = { "error", "warn" },
      symbols = {
        error = "󰅖",
        warn = "",
      },
    },
    git_diff = {
      "diff",
    },
    fname = {
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
    ftype = {
      "filetype",
      colored = false,
      icon_only = true,
    },
    loc = {
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
    prog = {
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

---Returns true if cwd is inside a git repo, false otherwise
---@return boolean
function M.is_git_repo()
  local cmd = { "git", "rev-parse", "--is-inside-git-dir" }
  local result = vim.system(cmd):wait()
  return result.code == 0
end

function M.git_local_changes_exists()
  local cmd = { "git", "status", "--porcelain" }
  local result = vim.system(cmd):wait()
  return result.stdout and #result.stdout > 0
end

function M.show_diff()
  return M.is_git_repo() and M.git_local_changes_exists()
end

---Sets telescope to search for config files
---@return function
function M.config_files()
  return require("telescope.builtin")["find_files"]({ cwd = vim.fn.stdpath("config") })
end

---Convenient new file prompt expansion for startup screen
function M.new_file_prompt()
  local path = ""
  local is_note = vim.fn.getcwd():find("self/notes")

  if is_note then
    path = vim.fn.expand("~") .. "/self/notes/main/inbox/"
  end

  vim.api.nvim_input(":e " .. path)
end

function M.expand_snip(snippet)
  local session = vim.snippet.active() and vim.snippet._session or nil

  local ok, err = pcall(vim.snippet.expand, snippet)
  if not ok then
    local fixed = M.snippet_fix(snippet)
    ok = pcall(vim.snippet.expand, fixed)

    local msg = ok and "Failed to parse snippet,\nbut was able to fix it automatically."
      or ("Failed to parse snippet.\n" .. err)

    local outstr = ([[%s
    ```%s
    %s
    ```]]):format(msg, vim.bo.filetype, snippet)
    vim.api.nvim_echo({ { outstr, ok and "Warn" or "Error" } }, true, {})
  end

  if session then
    vim.snippet._session = session
  end
end

return M
