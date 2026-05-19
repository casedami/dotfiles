require("fidget").setup({
	notification = {
		override_vim_notify = true,
		window = {
			winblend = 0,
		},
	},
})
require("gitsigns").setup({
	on_attach = function(bufnr)
		local gs = require("gitsigns")

    -- stylua: ignore start
		vim.keymap.set("n", "]h", function() if vim.wo.diff then vim.cmd.normal({ "]h", bang = true }) else gs.nav_hunk("next") end end, { buffer = bufnr, desc = "Git: goto next hunk" })
		vim.keymap.set("n", "[h", function() if vim.wo.diff then vim.cmd.normal({ "[h", bang = true }) else gs.nav_hunk("prev") end end, { buffer = bufnr, desc = "Git: goto previous hunk" })
		vim.keymap.set("n", "<localleader>hr", gs.reset_hunk, { buffer = bufnr, desc = "Git: reset hunk" })
		vim.keymap.set("n", "<localleader>hd", gs.diffthis, { buffer = bufnr, desc = "Git: diff hunk" })
		vim.keymap.set("n", "<localleader>hs", gs.stage_hunk, { buffer = bufnr, desc = "Git: stage hunk" })
		vim.keymap.set("v", "<localleader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { buffer = bufnr, desc = "Git: stage hunk" })
		vim.keymap.set("v", "<localleader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { buffer = bufnr, desc = "Git: reset hunk" })
	end,
})
