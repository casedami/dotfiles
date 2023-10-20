local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- change background of neo-tree depending on background mode
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  group = augroup("Color"),
  callback = function()
    if vim.o.background == "light" then
      vim.cmd("hi NeoTreeNormal guibg=#f3ead3")
      vim.cmd("hi NeoTreeEndOfBuffer guibg=#f3ead3")
    else
      vim.cmd("hi NeoTreeNormal guibg=#272e33")
      vim.cmd("hi NeoTreeEndOfBuffer guibg=#272e33")
    end
  end,
})
