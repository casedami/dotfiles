local set = vim.keymap.set

local function cd_root()
    local root = vim.fs.root(vim.fn.expand("%"), ".git")
    if root then
        vim.cmd.lcd(root)
        vim.cmd.pwd()
    else
        vim.notify("No .git root found", vim.log.levels.INFO)
    end
end

-- stylua: ignore start
-- Extend (ignored in selfhelp)
set("n", "<C-d>", "<C-d>zz", { desc = "Extend: center after page down" })
set("n", "<C-u>", "<C-u>zz", { desc = "Extend: center after page up" })
set("n", "n", "nztzv", { desc = "Extend: move to top of screen after next item in search" })
set("n", "N", "Nztzv", { desc = "Extend: move to top of screen after prev item in search" })
set("v", "<", "<gv", { desc = "Extend: stay in visual mode when indenting" })
set("v", ">", ">gv", { desc = "Extend: stay in visual mode when indenting" })
set("n", "/", "ms/", { desc = "Extend: mark last position before search" })
set("n", "0", "^", { desc = "Extend: goto beginning of line but ignore whitespace" })
set("v", "J", ":m '>+1<cr>gv=gv", { silent = true, desc = "Extend: move line up" })
set("v", "K", ":m '<-2<cr>gv=gv", { silent = true, desc = "Extend: move line down" })
set("n", "<localleader>p", "\"0p", {  desc = "Extend: forward paste from 0 register" })
set("n", "<localleader>P", "\"0P", {  desc = "Extend: backward paste from 0 register" })

-- Misc
set("n", "<localleader>l", "<cmd>Lazy<cr>", { desc = "Misc: open pacman" })
set("n", "<leader>?", "<cmd>h selfhelp.txt<cr>", { desc = "Misc: open selfhelp" })
set("n", "|", "<cmd>normal yygccp<cr>", { desc = "Misc: scratch line" })
set("v", "|", "<cmd>normal y`[V`]gc`]p<cr>", { desc = "Misc: scratch selected lines" })

-- Directory
set("n", "<leader>cd.", "<cmd>lcd %:h<bar>pwd<cr>", { desc = "Directory: change directory to parent of current file" })
set("n", "<leader>cdr", cd_root, { desc = "Directory: change directory to root of current file" })
set("n", "<leader>cdu", "<cmd>lcd ..<bar>pwd<cr>", { desc = "Directory: change directory to parent of cwd" })
set("n", "<leader>cd-", "<cmd>lcd -<bar>pwd<cr>", { desc = "Directory: change directory to previous cwd" })

-- Buffers
set("n", "<leader>pe", "<cmd>b#<cr>", { desc = "Buffer: previous buffer in current window" })
set("n", "<leader>ps", "<cmd>sp | b#<cr>", { desc = "Buffer: previous buffer in hsplit" })
set("n", "<leader>pv", "<cmd>vsp | b#<cr>", { desc = "Buffer: previous buffer in vsplit" })

-- TERM
set( "n", "<c-t>s", "<cmd>split | resize 15 | terminal<cr>i", { desc = "Term: open in hsplit" })
set( "n", "<c-t>v", "<cmd>vsplit | terminal<cr>i", { desc = "Term: open in vsplit" })
set( "t", "<esc>", "<C-\\><C-n>", { desc = "Extend: use esc key to switch normal mode from term mode" })
set( "t", "<c-x><esc>", "<esc>", { desc = "Extend: send esc key to shell" })

-- BookmarkS
set("n", "<leader>qa", function() vim.cmd("argadd %") vim.cmd("argdedup") end, { desc = "Bookmarks: add current file" })
set("n", "<leader>qd", function() vim.cmd("argdelete %") end, { desc = "Bookmarks: remove current file from bookmark list" })
set("n", "<leader>q1", function() vim.cmd("silent! 1argument") end, { desc = "Bookmarks: goto first" })
set("n", "<leader>q2", function() vim.cmd("silent! 2argument") end, { desc = "Bookmarks: goto second" })
set("n", "<leader>q3", function() vim.cmd("silent! 3argument") end, { desc = "Bookmarks: goto third" })
set("n", "<leader>q4", function() vim.cmd("silent! 4argument") end, { desc = "Bookmarks: goto fourth" })
