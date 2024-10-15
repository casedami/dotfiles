local function toggle_lightdark()
  if vim.o.background == "light" then
    vim.opt.background = "dark"
  else
    vim.opt.background = "light"
  end
end

local opts = {
  silent = { silent = true },
  noremap = { remap = false },
  remap = { remap = true },
}

-- Keymap namespaces:
-- f -> files
-- g -> git
-- c -> quickfix
-- w -> windows
-- d -> diagnostics/lsp
-- t -> terminal
-- \ -> buffers/tabs

local maps = {
  { "n", "<leader>l", "<cmd>Lazy<cr>", opts["silent"] }, -- open lazy
  { "n", "<leader>?", "<cmd>h selfhelp<cr>", opts["silent"] }, -- open selfhelp
  -- MOVEMENT
  { "n", "0", "^" }, -- remap inline movement (beginning of line)
  { "n", "<C-d>", "<C-d>zz" }, -- center after page down
  { "n", "<C-u>", "<C-u>zz" }, -- center after page up
  { "v", "J", ":m '>+1<cr>gv=gv", opts["silent"] }, -- move line up
  { "v", "K", ":m '<-2<cr>gv=gv", opts["silent"] }, -- move line down
  { "v", "<", "<gv" }, -- better indenting
  { "v", ">", ">gv" }, -- better indenting
  -- BUFFERS
  { "n", "<localleader>]", "<cmd>bnext<cr>" }, -- next buffer in bufferlist
  { "n", "<localleader>[", "<cmd>bprev<cr>" }, -- previous buffer in bufferlist
  { "n", "<localleader>d", "<cmd>bd<cr>" }, -- delete buffer
  { "n", "<localleader>p", "<C-6>" }, -- previous buffer
  { "n", "<localleader>P", "<C-w><C-6>" }, -- previous buffer in hsplit
  -- TABS
  { "n", "<localleader>}", "<cmd>tabnext<cr>" }, -- next tab
  { "n", "<localleader>{", "<cmd>tabprevious<cr>" }, -- previous tab
  { "n", "<localleader><tab>c", "<cmd>tabnew %<cr>" }, -- new tab
  { "n", "<localleader><tab>d", "<cmd>tabclose<cr>" }, -- close tab
  -- WINDOWS
  { "n", "<C-Up>", "<cmd>resize +2<cr>" }, -- increase window height
  { "n", "<C-Down>", "<cmd>resize -2<cr>" }, -- decrease window height
  { "n", "<C-Left>", "<cmd>vertical resize +2<cr>" }, -- decrease window width
  { "n", "<C-Right>", "<cmd>vertical resize -2<cr>" }, -- increase window width
  { "n", "<C-h>", "<C-w>h", opts["remap"] }, -- goto left window
  { "n", "<C-j>", "<C-w>j", opts["remap"] }, -- goto lower window
  { "n", "<C-k>", "<C-w>k", opts["remap"] }, -- goto upper window
  { "n", "<C-l>", "<C-w>l", opts["remap"] }, -- goto right window
  { "n", "<leader>wd", "<C-W>c", opts["remap"] }, -- delete window
  { "n", "<leader>we", "<C-W>=", opts["remap"] }, -- split windows equally
  { "n", "<leader>wo", "<C-W><C-O>", opts["remap"] }, -- make buffer the only buffer on screen
  { "n", "<leader>wk", "<C-W>_", opts["remap"] }, -- maximize current window vertically
  { "n", "<leader>wh", "<C-W>|", opts["remap"] }, -- maximize current window horizontally
  { "n", "<leader>wK", "<C-W>K", opts["remap"] }, -- change hsplit layout to vsplit
  { "n", "<leader>wH", "<C-W>H", opts["remap"] }, -- change vsplit layout to hsplit
  { "n", "<leader>wr", "<C-W><C-R>", opts["remap"] }, -- rotate window layout (only works row-/column-wise)
  { "n", "<leader>-", "<C-W>s", opts["remap"] }, -- split window below
  { "n", "<leader>|", "<C-W>v", opts["remap"] }, -- split window right
  -- QUICK FIX LIST
  { "n", "<leader>cn", "<cmd>cnext<cr>" }, -- goto next item in qfix list
  { "n", "<leader>cnf", "<cmd>cnfile<cr>" }, -- goto first item in next file
  { "n", "<leader>cp", "<cmd>cprev<cr>" }, -- goto previous item in qfix list
  { "n", "<leader>cpf", "<cmd>cpfile<cr>" }, -- goto last item in previous file
  { "n", "<leader>co", "<cmd>copen<cr>" }, -- open qfix list
  { "n", "<leader>cc", "<cmd>cclose<cr>" }, -- close qfix list
  -- TERM KEYMAPS
  { "n", "<leader>tj", "<cmd>split | resize 15 | terminal<cr>i" }, -- open term in hsplit
  { "n", "<leader>tl", "<cmd>vsplit | terminal<cr>i" }, -- open term in vsplit
  { "n", "<leader>T", "<cmd>tabnew | term<cr>i" }, -- open term in new tab
  { "t", "<esc>", "<C-\\><C-n>" }, -- use esc key to switch normal mode from term mode
  { "t", "<C-v><esc>", "<esc>" }, -- send esc key to shell
  -- FILES
  { "ca", "new", "e %:h/" }, -- edit new file in current dir
  { "ca", "newk", "sp %:h/" }, -- edit new file in current dir (hsplit)
  { "ca", "newh", "vsp %:h/" }, --edit new file in current dir (vsplit)
  -- ABBREVIATIONS
  { "ca", "ws", "WriteSes" }, -- save session for cwd
  { "ca", "ds", "DelSes" }, -- delete session for cwd
  { "ca", "dm", "DelMarks" }, -- delete all marks
  -- MISC COMMAND SHORTCUTS
  { { "n", "v" }, ")", '"0p' }, -- forward paste from 0 register
  { { "n", "v" }, "(", '"0P' }, -- backward paste from 0 register
  { "i", "<C-p>", '"0p' }, -- paste from 0 register in insert mode
  { { "n", "v" }, "<leader>;", "q:" }, -- remap to command history
  { { "n", "v" }, "<leader>/", "q/" }, -- remap to search history
  { "n", "<tab>", "<nop>" }, -- remave tab (alias for <c-i>)
  { "n", "<C-i>", "<c-i>" }, -- restore jump-forward keymap (<c-i>)
  { "n", "<C-;>", "<c-l>" }, -- clear cmd line
  { "n", "<C-'>", "<cmd>nohlsearch|diffupdate|normal! <c-l><cR>" }, -- clear previous search match highlights
  { "n", "go", "<cmd>call append(line('.'),     repeat([''], v:count1))<cr>" }, -- insert empty newline below
  { "n", "gO", "<cmd>call append(line('.') - 1, repeat([''], v:count1))<cr>" }, -- insert empty newline above
  { "n", "<leader>uc", toggle_lightdark, opts["silent"] }, -- toggle light/dark mode
}

for _, v in pairs(maps) do
  opts = v[4] or {}
  vim.keymap.set(v[1], v[2], v[3], opts)
end

vim.api.nvim_create_user_command("DelMarks", function()
  vim.cmd("delm a-zA-Z")
  vim.cmd("wviminfo!")
  vim.cmd(
    ([[echohl DiagnosticInfo | echomsg "%s" | echohl None]]):format(
      " deleting marks..."
    )
  )
end, {})

-- SESSIONS
vim.api.nvim_create_user_command("WriteSes", function()
  vim.cmd("SessionManager save_current_session")
  local msg = vim.fn.getcwd() .. " session saved"
  vim.cmd("echo '" .. msg .. "'")
end, {})
vim.api.nvim_create_user_command("DelSes", function()
  vim.cmd("SessionManager delete_current_dir_session")
  local msg = vim.fn.getcwd() .. " session deleted"
  vim.cmd("echo '" .. msg .. "'")
end, {})
