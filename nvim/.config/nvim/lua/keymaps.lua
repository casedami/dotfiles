local set = vim.keymap.set

-- stylua: ignore start
-- Extend (ignored in selfhelp)
set("n", "<C-d>", "<C-d>zz", { desc = "Extend: center after page down" })
set("n", "<C-u>", "<C-u>zz", { desc = "Extend: center after page up" })
set("n", "n", "nzzzv", { desc = "Extend: center after next item in search" })
set("n", "N", "Nzzzv", { desc = "Extend: center after prev item in search" })
set("v", "<", "<gv", { desc = "Extend: stay in visual mode when indenting" })
set("v", ">", ">gv", { desc = "Extend: stay in visual mode when indenting" })
set("n", "p", "zp", { desc = "Extend: prefer zp over p for paste behavior" })
set("n", "P", "zP", { desc = "Extend: prefer zP over P for paste behavior" })
set("x", "p", "zy", { desc = "Extend: prefer zy over p for paste behavior" })
set("n", "gV", "'[v']", { desc = "Extend: select last inserted/edited text" })
set("x", ".", "<cmd>normal .<cr>", { desc = "Extend: repeat last command for each line of visual mode" })
set("n", "/", "ms/", { desc = "Extend: mark last position before search" })
set("n", "0", "^", { desc = "Extend: goto beginning of line but ignore whitespace" })
set("v", "J", ":m '>+1<cr>gv=gv", { silent = true, desc = "Extend: move line up" })
set("v", "K", ":m '<-2<cr>gv=gv", { silent = true, desc = "Extend: move line down" })

-- Misc
set("n", "<localleader>l", "<cmd>Lazy<cr>", { desc = "Misc: open pacman" })
set("n", "<leader>?", "<cmd>h selfhelp.txt<cr>", { desc = "Misc: open selfhelp" })
set("n", "|", "<cmd>normal yygccp<cr>", { desc = "Misc: scratch line" })
set("v", "|", "<cmd>normal y`[V`]gc`]p<cr>", { desc = "Misc: scratch selected lines" })
set("n", "<C-;>", "<C-l>", { desc = "Misc: clear cmd line" })
set("n", "<C-'>", "<cmd>nohlsearch<cr>", { desc = "Misc: clear search highlights" })

-- Directory
set("n", "<leader>cdc", "<cmd>lcd %:h<bar>pwd<cr>", { desc = "Directory: change directory to parent of current file" })
set("n", "<leader>cdd", function() local root = vim.fs.root(vim.fn.expand("%"), ".git") if root then vim.cmd.lcd(root) vim.cmd.pwd() else vim.notify("No .git root found", vim.log.levels.WARN) end end, { desc = "Misc: change directory to root of current file" })
set("n", "<leader>cdu", "<cmd>lcd ..<bar>pwd<cr>", { desc = "Directory: change directory to parent of cwd" })
set("n", "<leader>cd-", "<cmd>lcd -<bar>pwd<cr>", { desc = "Directory: change directory to previous cwd" })

-- Movement
set("c", "<C-k>", "<up>", { desc = "Movement: go backwards in cmd history" })
set("c", "<C-j>", "<down>", { desc = "Movement: go forwards in cmd history" })

-- Buffers
set( "n", "<localleader>p", "<C-6>", { desc = "Buffer: previous" })
set( "n", "<localleader>P", "<C-w><C-6>", { desc = "Buffer: previous buffer in hsplit" })
set("n", "<leader>fe", function() if vim.bo.filetype == "netrw" then vim.cmd("b#") else vim.cmd("Ex") end end, { desc = "Finder: Toggle netrw buffer" })

-- Tabs
set( "n", "<localleader>]", "<cmd>tabnext<cr>", { desc = "Tab: next" })
set( "n", "<localleader>[", "<cmd>tabprevious<cr>", { desc = "Tab: previous" })
set( "n", "<leader>tc", "<cmd>tabnew %<cr>", { desc = "Tab: new" })
set( "n", "<leader>td", "<cmd>tabclose<cr>", { desc = "Tab: close" })

-- Windows
set( { "n", "v" }, "<C-h>", "<C-w>h", { desc = "Window: focus left" })
set( { "n", "v" }, "<C-j>", "<C-w>j", { desc = "Window: focus down" })
set( { "n", "v" }, "<C-k>", "<C-w>k", { desc = "Window: focus up" })
set( { "n", "v" }, "<C-l>", "<C-w>l", { desc = "Window: focus right" })

-- TERM
set( "n", "<leader>ts", "<cmd>split | resize 15 | terminal<cr>i", { desc = "Term: open in hsplit" })
set( "n", "<leader>tv", "<cmd>vsplit | terminal<cr>i", { desc = "Term: open in vsplit" })
set( "t", "<esc>", "<C-\\><C-n>", { desc = "Extend: use esc key to switch normal mode from term mode" })
set( "t", "<C-v><esc>", "<esc>", { desc = "Extend: send esc key to shell" })

-- BookmarkS
set("n", "<leader>qa", function() vim.cmd("argadd %") vim.cmd("argdedup") end, { desc = "Bookmarks: add current file" })
set("n", "<leader>qd", function() vim.cmd("argdelete %") end, { desc = "Bookmarks: remove current file from bookmark list" })
set("n", "<leader>q1", function() vim.cmd("silent! 1argument") end, { desc = "Bookmarks: goto first" })
set("n", "<leader>q2", function() vim.cmd("silent! 2argument") end, { desc = "Bookmarks: goto second" })
set("n", "<leader>q3", function() vim.cmd("silent! 3argument") end, { desc = "Bookmarks: goto third" })
set("n", "<leader>q4", function() vim.cmd("silent! 4argument") end, { desc = "Bookmarks: goto fourth" })
