local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- highlight text on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- don't auto-comment when o/O in normal mode
vim.api.nvim_create_autocmd("BufEnter", {
  group = augroup("no_auto_comment"),
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
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

-- only show tabline when more than one tab open
vim.api.nvim_create_autocmd({ "TabNew", "VimEnter" }, {
  group = augroup("show_tab_line"),
  callback = function()
    if vim.cmd("echo len(gettabinfo())") == "1" then
      vim.cmd("set showtabline=0")
    else
      vim.cmd("set showtabline=1")
    end
  end,
})

-- toggleterm keymaps
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    local opts = { buffer = 0 }
    vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
    vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
    vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
    vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
    vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
    vim.keymap.set("t", "<C-w>", "<esc><cmd>q<cr>")
  end,
})

-- lsp keymaps
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    -- buffer local mappings
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- FIX: not working?
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts) -- FIX: not working?
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts) -- FIX: not working?
    vim.keymap.set("n", "<space>rr", vim.lsp.buf.rename, opts)
    vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<space>fo", function()
      vim.lsp.buf.format({ async = true })
    end, opts)
  end,
})
