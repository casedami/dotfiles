-- Highlight text on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.g.utils.augroup("highlight_yank"),
	desc = "highlight text on yank",
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Open buf to last location
vim.api.nvim_create_autocmd("BufReadPost", {
	group = vim.g.utils.augroup("last_loc"),
	desc = "go to last loc when opening buffer",
	callback = function(event)
		local exclude = { "gitcommit" }
		local buf = event.buf
		if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
			return
		end
		vim.b[buf].lazyvim_last_loc = true
		local mark = vim.api.nvim_buf_get_mark(buf, '"')
		local lcount = vim.api.nvim_buf_line_count(buf)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- Set term buf opts
vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.g.utils.augroup("term"),
	desc = "set win opts when opening term buf",
	callback = function()
		vim.opt_local.spell = false
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
		vim.opt_local.signcolumn = "no"
		vim.keymap.set("n", "q", "<cmd>bd!<cr>", { buffer = true })
	end,
})

local ns_marks = vim.api.nvim_create_namespace("marksigns")

-- Show a-zA-Z marks to status column
vim.api.nvim_create_autocmd("CursorMoved", {
	group = vim.g.utils.augroup("marks"),
	desc = "add marks to signcolumn",
	callback = function()
		local buf = vim.api.nvim_win_get_buf(0)
		local marks = vim.fn.getmarklist(buf)
		vim.api.nvim_buf_clear_namespace(buf, ns_marks, 0, -1)
		vim.list_extend(marks, vim.fn.getmarklist())
		for _, mark in ipairs(marks) do
			if mark.pos[1] == buf and mark.mark:match("[a-zA-Z]") then
				local lnum = mark.pos[2]
				vim.api.nvim_buf_set_extmark(buf, ns_marks, lnum - 1, 0, {
					id = lnum,
					sign_text = mark.mark:sub(2),
					priority = 1,
					sign_hl_group = "DiagnosticInfo",
					cursorline_hl_group = "DiagnosticInfo",
				})
			end
		end
	end,
})

vim.api.nvim_create_autocmd({ "WinEnter" }, {
	group = vim.g.utils.augroup("toggle_line_numbers_on"),
	desc = "Toggle relative line numbers on",
	callback = function()
		if vim.wo.nu then
			vim.wo.relativenumber = true
			vim.wo.cursorline = true
			vim.wo.cursorcolumn = true
		end
	end,
})
vim.api.nvim_create_autocmd({ "WinLeave" }, {
	group = vim.g.utils.augroup("toggle_line_numbers_off"),
	desc = "Toggle relative line numbers off",
	callback = function()
		if vim.wo.nu then
			vim.wo.relativenumber = false
			vim.wo.cursorline = false
			vim.wo.cursorcolumn = false
		end
	end,
})
