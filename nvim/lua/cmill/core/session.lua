local M = {}

local Path = require("plenary.path")
local PATH_SEP = "__"
local COLON_SEP = "++"
local SESSIONS_DIR = Path:new(vim.fn.stdpath("data"), "sessions")

---@private
function M.session_name_to_dir(fname)
  local dir = fname:sub(#tostring(SESSIONS_DIR) + 2)
  dir = dir:gsub(COLON_SEP, ":")
  dir = dir:gsub(PATH_SEP, Path.path.sep)
  return Path:new(dir)
end

---@private
function M.dir_to_session_name(dir)
  local fname = dir:gsub(":", COLON_SEP)
  fname = fname:gsub(Path.path.sep, PATH_SEP)
  return Path:new(SESSIONS_DIR):joinpath(fname)
end

---@private
function M.session_exists()
  local cwd = vim.uv.cwd()
  if cwd then
    local session = M.dir_to_session_name(cwd)
    return session:exists()
  end
  return false
end

---@private
function M.is_restorable(bufnr)
  if #vim.api.nvim_get_option_value("bufhidden", { buf = bufnr }) ~= 0 then
    return false
  end

  local buftype = vim.api.nvim_get_option_value("buftype", { buf = bufnr })
  if #buftype == 0 then
    -- Normal buffer, check if it listed.
    if not vim.api.nvim_get_option_value("buflisted", { buf = bufnr }) then
      return false
    end
    -- Check if it has a filename.
    if #vim.api.nvim_buf_get_name(bufnr) == 0 then
      return false
    end
  elseif buftype ~= "terminal" and buftype ~= "help" then
    -- Buffers other then normal, terminal and help are impossible to restore.
    return false
  end

  if
    vim.tbl_contains({
      "gitcommit",
      "gitrebase",
    }, vim.api.nvim_get_option_value("filetype", { buf = bufnr }))
    or vim.tbl_contains({}, vim.api.nvim_get_option_value("buftype", { buf = bufnr }))
  then
    return false
  end
  return true
end

function M.load_session()
  if not M.session_exists() then
    local msg = "no session found for cwd: " .. '"' .. vim.fn.getcwd() .. '"'
    vim.notify("echo '" .. msg .. "'", vim.log.levels.WARN)
    return
  end

  local fname = M.dir_to_session_name(vim.uv.cwd()).filename

  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_get_option_value("modified", { buf = bufnr }) then
      local choice = vim.fn.confirm(
        "The files in the current session have changed. Save changes?",
        "&Yes\n&No\n&Cancel"
      )
      if choice == 3 or choice == 0 then
        return
      elseif choice == 1 then
        vim.api.nvim_command("silent wall")
      end
      break
    end
  end

  local current_buf = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and buf ~= current_buf then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
  vim.api.nvim_buf_delete(current_buf, { force = true })

  local swapfile = vim.o.swapfile
  vim.o.swapfile = false
  vim.api.nvim_command("silent source " .. fname)
  vim.o.swapfile = swapfile

  local msg = '"' .. vim.fn.getcwd() .. '"' .. " session loaded"
  vim.notify(msg, vim.log.levels.INFO, {})
end

function M.save_session()
  local cwd = vim.uv.cwd()
  if not cwd then
    vim.notify(
      "session: something went wrong (cwd not found)!",
      vim.log.levels.ERROR,
      {}
    )
    return false
  end

  local fname = M.dir_to_session_name(cwd).filename
  SESSIONS_DIR = Path:new(tostring(SESSIONS_DIR))
  if not SESSIONS_DIR:is_dir() then
    SESSIONS_DIR:mkdir()
  end

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and not M.is_restorable(buf) then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end

  if vim.fn.argc() > 0 then
    vim.api.nvim_command("%argdel")
  end

  vim.api.nvim_command("mksession! " .. fname)

  local msg = '"' .. vim.fn.getcwd() .. '"' .. " session saved"
  vim.notify(msg, vim.log.levels.INFO, {})
end

function M.delete_session()
  local cwd = vim.uv.cwd()
  if cwd then
    local session = M.dir_to_session_name(cwd)
    if session:exists() then
      Path:new(session.filename):rm()
    end
  end
  local msg = '"' .. vim.fn.getcwd() .. '"' .. " session deleted"
  vim.notify(msg, vim.log.levels.INFO, {})
end

return M
