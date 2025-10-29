local set = vim.keymap.set

-- stylua: ignore start
-- MISC
set( "n", "<localleader>l", "<cmd>Lazy<cr>", { desc = "Misc: open pacman" })
set( "n", "<localleader>?", "<cmd>h selfhelp.txt<cr>", { desc = "Misc: open selfhelp" })
set( { "n", "v" }, "=", '"0p', { desc = "Misc: paste 0 register (forward)" })
set( { "n", "v" }, "+", '"0P', { desc = "Misc: paste 0 register (backward)" })
set( "i", "<C-p>", '<C-o>"0p', { desc = "Misc: paste 0 register (insert mode)" })
set( "n", "|", "<cmd>normal yygccp<cr>", { desc = "Misc: scratch line" })
set( "v", "|", "<cmd>normal y`[V`]gc`]p<cr>", { desc = "Misc: scratch selected lines" })
set( "n", "<C-;>", "<C-l>", { desc = "Misc: clear cmd line" })
set( "n", "<C-'>", "<cmd>nohlsearch|diffupdate|normal! <c-l><cR>", { desc = "Misc: clear search highlights" })
set( "ca", "currdir", "cd %:h", { desc = "Misc: cwd expansion" })

-- MOVEMENT
set("n", "0", "^", { desc = "Movement: goto beginning of line" })
set("n", ")", "$", { desc = "Movement: goto end of line" })
set("v", "J", ":m '>+1<cr>gv=gv", { silent = true, desc = "Movement: move line up" })
set("v", "K", ":m '<-2<cr>gv=gv", { silent = true, desc = "Movement: move line down" })
set("c", "<C-k>", "<up>", { desc = "Movement: go backwards in cmd history" })
set("c", "<C-j>", "<down>", { desc = "Movement: go forwards in cmd history" })
set("n", "<C-d>", "<C-d>zz", { desc = "Extend: center after page down" })
set("n", "<C-u>", "<C-u>zz", { desc = "Extend: center after page up" })
set("n", "n", "nzzzv", { desc = "Extend: center after next item in search" })
set("n", "N", "Nzzzv", { desc = "Extend: center after prev item in search" })
set("v", "<", "<gv", { desc = "Extend: stay in visual mode when indenting" })
set("v", ">", ">gv", { desc = "Extend: stay in visual mode when indenting" })

-- BUFFERS
set( "n", "<localleader>]", "<cmd>bnext<cr>", { desc = "Buffer: next" })
set( "n", "<localleader>[", "<cmd>bprev<cr>", { desc = "Buffer: previous" })
set( "n", "<localleader>d", "<cmd>bd<cr>", { desc = "Buffer: close" })
set( "n", "<localleader>p", "<C-6>", { desc = "Buffer: previous" })
set( "n", "<localleader>P", "<C-w><C-6>", { desc = "Buffer: previous buffer in hsplit" })

-- TABS
set( "n", "<localleader>}", "<cmd>tabnext<cr>", { desc = "Tab: next" })
set( "n", "<localleader>{", "<cmd>tabprevious<cr>", { desc = "Tab: previous" })
set( "n", "<localleader><tab>c", "<cmd>tabnew %<cr>", { desc = "Tab: new" })
set( "n", "<localleader><tab>d", "<cmd>tabclose<cr>", { desc = "Tab: close" })

-- WINDOWS
set( "n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Window: increase height" })
set( "n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Window: decrease height" })
set( "n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Window: decrease width" })
set( "n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Window: increase width" })
set( { "n", "v" }, "<C-h>", "<C-w>h", { desc = "Window: focus left" })
set( { "n", "v" }, "<C-j>", "<C-w>j", { desc = "Window: focus down" })
set( { "n", "v" }, "<C-k>", "<C-w>k", { desc = "Window: focus up" })
set( { "n", "v" }, "<C-l>", "<C-w>l", { desc = "Window: focus right" })
set( "n", "<leader>wd", "<C-W>c", { desc = "Window: close" })
set( "n", "<leader>we", "<C-W>=", { desc = "Window: split equally" })
set( "n", "<leader>wo", "<C-W><C-O>", { desc = "Window: focus" })
set( "n", "<leader>wk", "<C-W>_", { desc = "Window: maximize current window vertically" })
set( "n", "<leader>wh", "<C-W>|", { desc = "Window: maximize current window horizontally" })
set( "n", "<leader>wK", "<C-W>K", { desc = "Window: hsplit to vsplit" })
set( "n", "<leader>wH", "<C-W>H", { desc = "Window: vsplit to hsplit" })
set( "n", "<leader>wr", "<C-W><C-R>", { desc = "Window: rotate (single-axis only)" })
set( "n", "<leader>-", "<C-W>s", { desc = "Window: vsplit" })
set( "n", "<leader>|", "<C-W>v", { desc = "Window: hsplit" })

-- TERM
set( "n", "<leader>tk", "<cmd>split | resize 15 | terminal<cr>i", { desc = "Term: open in hsplit" })
set( "n", "<leader>th", "<cmd>vsplit | terminal<cr>i", { desc = "Term: open in vsplit" })
set( "n", "<leader>T", "<cmd>tabnew | term<cr>i", { desc = "Term: open in new tab" })
set( "t", "<esc>", "<C-\\><C-n>", { desc = "Extend: use esc key to switch normal mode from term mode" })
set( "t", "<C-v><esc>", "<esc>", { desc = "Extend: send esc key to shell" })

-- BOOKMARKS
set("n", "<leader>qa", function() vim.cmd("argadd %") vim.cmd("argdedup") end, { desc = "Bookmarks: add current file" })
set("n", "<leader>qd", function() vim.cmd("argdelete %") end, { desc = "Bookmarks: remove current file from bookmark list" })
set("n", "<leader>q1", function() vim.cmd("silent! 1argument") end, { desc = "Bookmarks: goto first" })
set("n", "<leader>q2", function() vim.cmd("silent! 2argument") end, { desc = "Bookmarks: goto second" })
set("n", "<leader>q3", function() vim.cmd("silent! 3argument") end, { desc = "Bookmarks: goto third" })
set("n", "<leader>q4", function() vim.cmd("silent! 4argument") end, { desc = "Bookmarks: goto fourth" })
