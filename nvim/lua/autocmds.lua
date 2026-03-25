vim.api.nvim_create_autocmd("VimEnter", {
	group = vim.api.nvim_create_augroup("casedami/splash", { clear = true }),
	desc = "add keymaps to start screen",
	callback = function()
		if vim.fn.argc() ~= 0 then
			return
		end
		local keymaps = {
			{ key = "f", cmd = "<cmd>FzfLua files<cr>" },
			{ key = "r", cmd = "<cmd>FzfLua oldfiles<cr>" },
			{ key = "g", cmd = "<cmd>FzfLua live_grep<cr>" },
			{ key = "s", cmd = "<cmd>Session select<cr>" },
			{ key = "qq", cmd = "<cmd>q!<cr>" },
		}

		vim.api.nvim_set_option_value("modifiable", false, { buf = 1 })
		for _, m in ipairs(keymaps) do
			vim.keymap.set("n", m.key, m.cmd, { buffer = true, nowait = true })
		end
	end,
	once = true,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("casedami/highlight_on_yank", { clear = true }),
	desc = "highlight text on yank",
	callback = function()
		vim.hl.on_yank()
	end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
	group = vim.api.nvim_create_augroup("casedami/last_loc", { clear = true }),
	desc = "move cursor to last loc when opening buffer",
	callback = function(args)
		local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
		local line_count = vim.api.nvim_buf_line_count(args.buf)
		if mark[1] > 0 and mark[1] <= line_count then
			vim.cmd('normal! g`"zz')
		end
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("casedami/close_with_q", { clear = true }),
	desc = "close with <q>",
	pattern = {
		"git",
		"help",
		"man",
		"qf",
		"scratch",
	},
	callback = function(args)
		vim.keymap.set("n", "q", "<cmd>quit<cr>", { buffer = args.buf })
	end,
})

vim.api.nvim_create_autocmd("CmdwinEnter", {
	group = vim.api.nvim_create_augroup("casedami/persist_cmd_win", { clear = true }),
	desc = "keep command window open after running command",
	callback = function(args)
		vim.keymap.set("n", "q", "<cmd>quit<cr>", { buffer = args.buf })
		vim.keymap.set("n", "<C-CR>", "<CR>q:", { buffer = args.buf })
	end,
})

vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("casedami/term_close_with_q", { clear = true }),
	desc = "close with <q>",
	callback = function(args)
		vim.keymap.set("n", "q", "<cmd>bd!<cr>", { buffer = args.buf })
	end,
})

local ns_marks = vim.api.nvim_create_namespace("marksigns")
vim.api.nvim_create_autocmd("CursorMoved", {
	group = vim.api.nvim_create_augroup("casedami/marks", { clear = true }),
	desc = "show a-zA-Z marks in signcolumn",
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

local group_toggle_relnum = vim.api.nvim_create_augroup("casedami/toggle_relnum", {})
vim.api.nvim_create_autocmd({ "WinEnter" }, {
	group = group_toggle_relnum,
	desc = "toggle relative line numbers on for focused buf",
	callback = function()
		if vim.wo.nu then
			vim.wo.relativenumber = true
			vim.wo.cursorline = true
			vim.wo.cursorcolumn = true
		end
	end,
})
vim.api.nvim_create_autocmd({ "WinLeave" }, {
	group = group_toggle_relnum,
	desc = "toggle relative line numbers off for unfocused buf(s)",
	callback = function()
		if vim.wo.nu then
			vim.wo.relativenumber = false
			vim.wo.cursorline = false
			vim.wo.cursorcolumn = false
		end
	end,
})
