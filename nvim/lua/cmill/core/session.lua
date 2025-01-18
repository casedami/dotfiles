local M = {}
M.active_session_filename = nil

local Path = require("plenary.path")
local path_replacer = "__"
local colon_replacer = "++"
local sessions_dir = Path:new(vim.fn.stdpath("data"), "sessions")

---@private
function M.session_filename_to_dir(filename)
  local dir = filename:sub(#tostring(sessions_dir) + 2)
  dir = dir:gsub(colon_replacer, ":")
  dir = dir:gsub(path_replacer, Path.path.sep)
  return Path:new(dir)
end

---@private
function M.dir_to_session_filename(dir)
  local filename = dir:gsub(":", colon_replacer)
  filename = filename:gsub(Path.path.sep, path_replacer)
  return Path:new(sessions_dir):joinpath(filename)
end

---@private
function M.session_exists()
  local cwd = vim.uv.cwd()
  if cwd then
    local session = M.dir_to_session_filename(cwd)
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
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_get_option_value("modified", { buf = bufnr }) then
      local choice = vim.fn.confirm(
        "The files in the current session have changed. Save changes?",
        "&Yes\n&No\n&Cancel"
      )
      if choice == 3 or choice == 0 then
        return -- Cancel.
      elseif choice == 1 then
        vim.api.nvim_command("silent wall")
      end
      break
    end
  end
end

---@private
local function save_session(filename)
  sessions_dir = Path:new(tostring(sessions_dir))
  if not sessions_dir:is_dir() then
    sessions_dir:mkdir()
  end

  for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buffer) and not M.is_restorable(buffer) then
      vim.api.nvim_buf_delete(buffer, { force = true })
    end
  end

  if vim.fn.argc() > 0 then
    vim.api.nvim_command("%argdel")
  end

  M.active_session_filename = filename

  vim.api.nvim_exec_autocmds("User", { pattern = "SessionSavePre" })
  vim.api.nvim_command("mksession! " .. filename)
  vim.api.nvim_exec_autocmds("User", { pattern = "SessionSavePost" })
end

function M.save_session()
  local cwd = vim.uv.cwd()
  if cwd then
    save_session(M.dir_to_session_filename(cwd).filename)
  end
end

function M.delete_session()
  local cwd = vim.uv.cwd()
  if cwd then
    local session = M.dir_to_session_filename(cwd)
    if session:exists() then
      Path:new(session.filename):rm()
      if session.filename == M.active_session_filename then
        M.active_session_filename = nil
      end
    end
  end
end

return M
