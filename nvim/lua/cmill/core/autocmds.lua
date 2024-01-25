local map = vim.keymap.set

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

-- toggleterm keymaps
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    local opts = { buffer = 0 }
    map("t", "<esc>", [[<C-\><C-n>]], opts)
    map("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
    map("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
    map("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
    map("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
    map("t", "<C-w>", "<esc><cmd>q<cr>")
  end,
})

-- lsp keymaps
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
    local builtins = require("telescope.builtin")

    -- lsp
    local opts = { buffer = ev.buf }
    map("n", "K", vim.lsp.buf.hover, opts)
    map("n", "gd", builtins.lsp_definitions, opts)
    map("n", "gD", vim.lsp.buf.declaration, opts)
    map("n", "<leader>rr", vim.lsp.buf.rename, opts)
    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
    map("n", "<leader>ci", builtins.lsp_implementations, opts)
    map("n", "<leader>cr", builtins.lsp_references, opts)
    map("n", "<leader>ld", vim.diagnostic.open_float, opts)
    map("n", "<leader>cd", builtins.diagnostics, opts)

    -- diagnostics
    local diagnostic_goto = function(next, severity)
      local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
      severity = severity and vim.diagnostic.severity[severity] or nil
      return function()
        go({ severity = severity })
      end
    end
    map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
    map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
    map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
    map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
    map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
    map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })
  end,
})
