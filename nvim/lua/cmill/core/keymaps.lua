local function toggle_colorcolumn()
  if vim.o.colorcolumn == "" then
    vim.opt.colorcolumn = "88"
  else
    vim.opt.colorcolumn = ""
  end
end

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
  { "n", "<localleader>bd", "<cmd>bd<cr>" }, -- delete buffer
  { "n", "<localleader>p", "<C-6>" }, -- previous buffer
  { "n", "<localleader>bb", "<cmd>ls<cr>:b<space>" }, -- change buffer via buflist preview
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
  { "n", "<leader>-", "<C-W>s", opts["remap"] }, -- split window below
  { "n", "<leader>|", "<C-W>v", opts["remap"] }, -- split window right
  { "n", "<leader>we", "<C-W>=", opts["remap"] }, -- split windows equally
  { "n", "<leader>wk", "<C-W>_", opts["remap"] }, -- maximize current window vertically
  { "n", "<leader>wj", "<C-W>_", opts["remap"] }, -- maximize current window vertically
  { "n", "<leader>wh", "<C-W>|", opts["remap"] }, -- maximize current window horizontally
  { "n", "<leader>wl", "<C-W>|", opts["remap"] }, -- maximize current window horizontally
  -- QUICK FIX LIST
  { "n", "<localleader>qnn", "<cmd>cnext<cr>" }, -- goto next item in qfix list
  { "n", "<localleader>qnf", "<cmd>cnfile<cr>" }, -- goto first item in next file
  { "n", "<localleader>qpp", "<cmd>cprev<cr>" }, -- goto previous item in qfix list
  { "n", "<localleader>qpf", "<cmd>cpfile<cr>" }, -- goto last item in previous file
  { "n", "<localleader>qo", "<cmd>copen<cr>" }, -- open qfix list
  { "n", "<localleader>qc", "<cmd>cclose<cr>" }, -- close qfix list
  -- TERM KEYMAPS
  { "n", "<leader>t", "<cmd>split | resize 15 | terminal<cr>i" }, -- open term in hsplit
  { "n", "<leader>T", "<cmd>tabnew | term<cr>i" }, -- open term in new tab
  { "t", "<esc>", "<C-\\><C-n>" }, -- use esc key to switch normal mode from term mode
  { "t", "<C-v><esc>", "<esc>" }, -- send esc key to shell
  -- MISC COMMAND SHORTCUTS
  { "n", "<localleader>e", ":e <C-R>=expand('%:p:h') . '/' <CR>" }, -- edit new file in current dir
  { "n", "<localleader>es", ":sp <C-R>=expand('%:p:h') . '/' <CR>" }, -- edit new file in current dir (hsplit)
  { "n", "<localleader>ev", ":vsp <C-R>=expand('%:p:h') . '/' <CR>" }, --edit new file in current dir (vsplit)
  { "n", "<leader>sr", ":s/" }, -- start search and replace
  { "n", "<leader>S", ":%s/" }, -- start global search and replace
  { { "n", "v" }, ")", '"0p' }, -- forward paste from 0 register
  { { "n", "v" }, "(", '"0P' }, -- backward paste from 0 register
  { "i", "<C-p>", '"0p' }, -- paste from 0 register in insert mode
  { { "n", "v" }, "<leader>qq", "q:" }, -- remap to command history
  { { "n", "v" }, "<leader>Q", "q/" }, -- remap to search history
  { { "n", "v" }, "q", "<nop>" }, -- remove macro ...
  { { "n", "v" }, "Q", "<nop>" }, -- remove Q
  { "n", "<tab>", "<nop>" }, -- remave tab (alias for <c-i>)
  { "n", "<C-;>", "<C-l>" }, -- clear cmd line
  { "n", "go", "<cmd>call append(line('.'),     repeat([''], v:count1))<cr>" }, -- insert empty newline below
  { "n", "gO", "<cmd>call append(line('.') - 1, repeat([''], v:count1))<cr>" }, -- insert empty newline above
  { "n", "<leader>!", toggle_colorcolumn }, -- toggle color column
  { "n", "<leader>uc", toggle_lightdark, opts["silent"] }, -- toggle light/dark mode
  { "n", "<leader>ss", "<cmd>Pstart<cr>", opts["silent"] }, -- start pomodoro
  { "n", "<leader>sq", "<cmd>Pstop<cr>", opts["silent"] }, -- stop pomodoro
  { "x", "<localleader>ff", ":!pandoc -t commonmark_x<cr>" }, -- auto format selected markdown table
  { "n", "<C-'>", "<Cmd>nohlsearch|diffupdate|normal! <C-l><CR>" }, -- stop highlighting previous search matches
  -- ABBREVIATIONS
  { "ca", "ws", "WriteSes" }, -- save session for cwd
  { "ca", "ds", "DelSes" }, -- delete session for cwd
  { "ca", "dm", "DelMarks" }, -- delete all marks
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
