local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  group = augroup("Color"),
  callback = function()
    vim.cmd("hi NeoTreeNormal guibg=#272e33")
    vim.cmd("hi NeoTreeEndOfBuffer guibg=#272e33")
  end,
})
