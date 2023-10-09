-- Autocmds are automatically loaded on the VeryLazy event

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "<space>rr", vim.lsp.buf.rename, opts)
    vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<space>fo", function()
      vim.lsp.buf.format({ async = true })
    end, opts)

    local bfr = vim.api.nvim_get_current_buf()
    local ft = vim.api.nvim_buf_get_option(bfr, "filetype")
    if ft == "markdown" then
      vim.keymap.set("n", "<localleader>ll", "<cmd>ObsidianOpen<cr>")
      vim.keymap.set("n", "<localleader>gd", "<cmd>ObsidianFollowLink<cr>")
      vim.keymap.set("n", "<localleader>ff", "<cmd>ObsidianBacklinks")
      vim.keymap.set("n", "<localleader>t", "<cmd>ObsidianTemplate")
    end
  end,
})
