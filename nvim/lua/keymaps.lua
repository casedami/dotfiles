-- stylua: ignore start
-- Extend (ignored in selfhelp)
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Extend: center after page down" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Extend: center after page up" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Extend: move to top of screen after next item in search" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Extend: move to top of screen after prev item in search" })
vim.keymap.set("v", "<", "<gv", { desc = "Extend: stay in visual mode when indenting" })
vim.keymap.set("v", ">", ">gv", { desc = "Extend: stay in visual mode when indenting" })
vim.keymap.set("n", "/", "ms/", { desc = "Extend: mark last position before search" })
vim.keymap.set("v", "J", ":m '>+1<cr>gv=gv", { silent = true, desc = "Extend: move line up" })
vim.keymap.set("v", "K", ":m '<-2<cr>gv=gv", { silent = true, desc = "Extend: move line down" })
vim.keymap.set({"n", "v"}, "<localleader>p", "\"0p", {  desc = "Extend: forward paste from 0 register" })
vim.keymap.set({"n", "v"}, "<localleader>P", "\"0P", {  desc = "Extend: backward paste from 0 register" })
vim.keymap.set("n", "zp", "vipzf", { desc = "Extend: fold inside paragraph" })
vim.keymap.set("n", "zP", "vapzf", { desc = "Extend: fold around paragraph" })

-- Misc
vim.keymap.set("n", "<leader>?", "<cmd>h selfhelp.txt<cr>", { desc = "Misc: open selfhelp" })
vim.keymap.set("n", "|", "<cmd>normal yygccp<cr>", { desc = "Misc: scratch line" })
vim.keymap.set("v", "|", "<cmd>normal y`[V`]gc`]p<cr>", { desc = "Misc: scratch selected lines" })
vim.keymap.set("ca", "packup", "lua vim.pack.update()", { desc = "Misc: shorthand for updating plugins" })

-- Directory
vim.keymap.set("n", "<leader>cd.", "<cmd>lcd %:h<cr>", { desc = "Directory: change directory to parent of current file" })
vim.keymap.set("n", "<leader>cdu", "<cmd>lcd ..<cr>", { desc = "Directory: change directory to parent of cwd" })
vim.keymap.set("n", "<leader>cdr", vim.g.utils.cd_root, { desc = "Directory: change directory to root of current file" })
vim.keymap.set("n", "<leader>cd-", "<cmd>lcd -<cr>", { desc = "Directory: change directory to previous cwd" })

-- Buffers
vim.keymap.set("n", "<leader>pe", "<cmd>b#<cr>", { desc = "Buffer: previous buffer in current window" })
vim.keymap.set("n", "<leader>ps", "<cmd>sp | b#<cr>", { desc = "Buffer: previous buffer in hsplit" })
vim.keymap.set("n", "<leader>pv", "<cmd>vsp | b#<cr>", { desc = "Buffer: previous buffer in vsplit" })

-- Term
vim.keymap.set("n", "<c-t>s", "<cmd>split | resize 15 | terminal<cr>i", { desc = "Term: open in hsplit" })
vim.keymap.set("n", "<c-t>v", "<cmd>vsplit | terminal<cr>i", { desc = "Term: open in vsplit" })
vim.keymap.set("t", "<esc>", "<C-\\><C-n>", { desc = "Extend: use esc key to switch normal mode from term mode" })
vim.keymap.set("t", "<c-x><esc>", "<esc>", { desc = "Extend: send esc key to shell" })

-- Bookmarks
vim.keymap.set("n", "<leader>qa", function() vim.cmd("argadd %") vim.cmd("argdedup") end, { desc = "Bookmarks: add current file" })
vim.keymap.set("n", "<leader>qd", function() vim.cmd("argdelete %") end, { desc = "Bookmarks: remove current file from bookmark list" })
for i=1,9 do
    vim.keymap.set("n", string.format("<leader>q%d", i), function() vim.cmd(string.format("silent! %dargument", i)) end, { desc = "Bookmarks: goto bookmark %d=[1-9]" })
end
