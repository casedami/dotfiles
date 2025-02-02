local M = {}

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
