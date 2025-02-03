local M = {}

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

return M
