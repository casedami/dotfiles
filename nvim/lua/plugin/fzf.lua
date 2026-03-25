vim.opt.guicursor:remove({ "t:block-blinkon500-blinkoff500-TermCursor" })
local fzf = require("fzf-lua")
fzf.setup({
	winopts = {
		backdrop = 100,
		height = 0.6,
		width = 0.8,
		row = 0.5,
		col = 0.5,
	},
	oldfiles = {
		cwd_only = true,
	},
	defaults = {
		color_icons = false,
	},
})

fzf.register_ui_select()

-- stylua: ignore start
vim.keymap.set("n", "<leader>F", "<cmd>FzfLua resume<cr>", { desc = "Finder: resume", silent = true })
vim.keymap.set("n", "<leader>f", "<cmd>FzfLua files<cr>", { desc = "Finder: files", silent = true })
vim.keymap.set("n", "<leader>r", "<cmd>FzfLua oldfiles<cr>", { desc = "Finder: recent files", silent = true })
vim.keymap.set("n", "<leader>o", "<cmd>FzfLua buffers<cr>", { desc = "Finder: open buffers", silent = true })
vim.keymap.set("n", "<leader>b", "<cmd>FzfLua args winopts.title='Bookmarks'<cr>", { desc = "Bookmarks: search bookmarks", silent = true })
vim.keymap.set("n", "<leader>g", "<cmd>FzfLua live_grep<cr>", { desc = "Finder: grep", silent = true })
vim.keymap.set("n", "<leader>G", "<cmd>FzfLua git_status<cr>", { desc = "Git: status", silent = true })
vim.keymap.set("n", "<leader>h", "<cmd>FzfLua helptags<cr>", { desc = "Finder: help", silent = true })
vim.keymap.set("n", "<leader>H", "<cmd>FzfLua highlights<cr>", { desc = "Finder: highlights", silent = true })

vim.keymap.set("n", "gd", "<cmd>FzfLua lsp_definitions<cr>", { desc = "LSP: definitions", silent = true })
vim.keymap.set("n", "grr", "<cmd>FzfLua lsp_references<cr>", { desc = "LSP: search references", silent = true })
vim.keymap.set("n", "<localleader>D", "<cmd>FzfLua diagnostics_workspace<cr>", { desc = "LSP: search workspace diagnostics", silent = true })

-- stylua: ignore end

-- Grep for todo items
vim.api.nvim_create_user_command("Todo", function()
	vim.cmd(
		[[ lua require("fzf-lua").live_grep({no_esc=true, search="(TODO|BUG|FIXME|WARN|NOTE|HACK|MARK)", winopts = {title="Todo Items"}}) ]]
	)
end, { desc = "Grep TODOs", nargs = 0 })

local function cdc(opts)
	local fzf_lua = require("fzf-lua")
	opts = opts or {}
	opts.prompt = "Directories> "
	opts.actions = {
		["default"] = function(selected)
			vim.cmd("lcd " .. selected[1])
		end,
	}
	fzf_lua.fzf_exec("fd --type d -H -E .git", opts)
end

-- stylua: ignore
vim.keymap.set( "n", "<leader>dc", cdc, { desc = "Directory: change directory (fzf)" })
