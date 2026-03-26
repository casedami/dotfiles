local function cd_root()
	local root = vim.fs.root(vim.fn.expand("%"), ".git")
	if root then
		vim.cmd.lcd(root)
	else
		vim.notify("No .git root found", vim.log.levels.INFO)
	end
end

-- stylua: ignore start
-- extend (ignored in selfhelp)
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Extend: center after page down" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Extend: center after page up" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Extend: move to top of screen after next item in search" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Extend: move to top of screen after prev item in search" })
vim.keymap.set("v", "<", "<gv", { desc = "Extend: stay in visual mode when indenting" })
vim.keymap.set("v", ">", ">gv", { desc = "Extend: stay in visual mode when indenting" })
vim.keymap.set("n", "/", "ms/", { desc = "Extend: mark last position before search" })
vim.keymap.set("v", "J", ":m '>+1<cr>gv=gv", { silent = true, desc = "Extend: move line up" })
vim.keymap.set("v", "K", ":m '<-2<cr>gv=gv", { silent = true, desc = "Extend: move line down" })
vim.keymap.set("n", "zp", "vipzf", { desc = "Extend: fold inside paragraph" })
vim.keymap.set("n", "zP", "vapzf", { desc = "Extend: fold around paragraph" })

-- misc
vim.keymap.set("n", "<leader>?", "<cmd>h selfhelp.txt<cr>", { desc = "Misc: open selfhelp" })
vim.keymap.set("ca", "packup", "lua vim.pack.update()", { desc = "Misc: shorthand for updating plugins" })

-- directory
vim.keymap.set("n", "<leader>d.", "<cmd>lcd %:h<cr>", { desc = "Directory: change directory to parent of current file" })
vim.keymap.set("n", "<leader>du", "<cmd>lcd ..<cr>", { desc = "Directory: change directory to parent of cwd" })
vim.keymap.set("n", "<leader>dr", cd_root, { desc = "Directory: change directory to root of current file" })
vim.keymap.set("n", "<leader>d-", "<cmd>lcd -<cr>", { desc = "Directory: change directory to previous cwd" })

-- buffers
vim.keymap.set("n", "<leader>pe", "<cmd>b#<cr>", { desc = "Buffer: previous buffer in current window" })
vim.keymap.set("n", "<leader>ps", "<cmd>sp | b#<cr>", { desc = "Buffer: previous buffer in hsplit" })
vim.keymap.set("n", "<leader>pv", "<cmd>vsp | b#<cr>", { desc = "Buffer: previous buffer in vsplit" })

-- term
vim.keymap.set("n", "<c-t>s", "<cmd>bel20new | term<cr>i", { desc = "Term: open in hsplit" })
vim.keymap.set("n", "<c-t>v", "<cmd>vert bo new | term<cr>i", { desc = "Term: open in vsplit" })
vim.keymap.set("t", "<esc>", "<C-\\><C-n>", { desc = "Extend: use esc key to switch normal mode from term mode" })

-- bookmarks
vim.api.nvim_create_user_command("Add", function()
  vim.cmd("argadd %") vim.cmd("argdedup")
end, { nargs = 0 })
vim.api.nvim_create_user_command("Drop", function()
  vim.cmd("argdelete %")
end, { nargs = 0 })

for i=1,7 do
    vim.keymap.set("n", string.format("<C-%d>", i), function() vim.cmd(string.format("silent! %dargument", i)) end, { desc = "Bookmarks: goto bookmark %d=[1-7]" })
end

vim.api.nvim_create_user_command("Scratch", function()
	vim.cmd("bel 10new")
	local buf = vim.api.nvim_get_current_buf()
	for name, value in pairs({
		filetype = "scratch",
		buftype = "nofile",
		bufhidden = "wipe",
		swapfile = false,
		modifiable = true,
	}) do
		vim.api.nvim_set_option_value(name, value, { buf = buf })
	end
end, { desc = "Open a scratch buffer", nargs = 0 })
