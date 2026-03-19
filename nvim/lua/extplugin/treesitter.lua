local ts = require("nvim-treesitter")
local ft_parsers = {
	sh = "bash",
	c = "c",
	comment = "comment",
	gitcommit = "gitcommit",
	gitignore = "gitignore",
	gitconfig = "git_config",
	json = "json",
	lua = "lua",
	markdown = { "markdown", "markdown_inline" },
	nu = "nu",
	python = "python",
	regex = "regex",
	rust = "rust",
	sql = "sql",
	toml = "toml",
	typst = "typst",
	vim = "vim",
	vimdoc = "vimdoc",
	yaml = "yaml",
}
ts.install(vim.iter(vim.tbl_values(ft_parsers)):flatten():totable()):wait(90000) -- force synchronous 1min 30sec wait

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("casedami/treesitter", { clear = true }),
	pattern = vim.tbl_keys(ft_parsers),
	callback = function()
		vim.treesitter.start()
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})

require("nvim-treesitter-textobjects").setup({
	move = {
		set_jumps = true,
	},
	select = {
		lookahead = true,
		selection_modes = {
			["@function.outer"] = "V", -- linewise
			["@class.outer"] = "V", -- blockwise
		},
		include_surrounding_whitespace = false,
	},
})

-- stylua: ignore start
vim.keymap.set({ "x", "o" }, "af", function() require("nvim-treesitter-textobjects.select").select_textobject( "@function.outer", "textobjects") end)
vim.keymap.set({ "x", "o" }, "if", function() require("nvim-treesitter-textobjects.select").select_textobject( "@function.inner", "textobjects") end)
vim.keymap.set({ "x", "o" }, "ac", function() require("nvim-treesitter-textobjects.select").select_textobject( "@class.outer", "textobjects") end)
vim.keymap.set({ "x", "o" }, "ic", function() require("nvim-treesitter-textobjects.select").select_textobject( "@class.inner", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "]f", function() require("nvim-treesitter-textobjects.move").goto_next_start( "@function.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "]c", function() require("nvim-treesitter-textobjects.move").goto_next_start( "@class.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "]l", function() require("nvim-treesitter-textobjects.move").goto_next_start( { "@loop.inner", "@loop.outer" }, "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "]F", function() require("nvim-treesitter-textobjects.move").goto_next_end( "@function.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "]C", function() require("nvim-treesitter-textobjects.move").goto_next_end( "@class.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "[f", function() require("nvim-treesitter-textobjects.move").goto_previous_start( "@function.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "[c", function() require("nvim-treesitter-textobjects.move").goto_previous_start( "@class.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "[F", function() require("nvim-treesitter-textobjects.move").goto_previous_end( "@function.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "[C", function() require("nvim-treesitter-textobjects.move").goto_previous_end( "@class.outer", "textobjects") end)
-- stylua: ignore end

-- fold treesitter function object
vim.keymap.set("n", "zm", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
	-- queue zf after the selection feedkeys have been processed
	local keys = vim.api.nvim_replace_termcodes("zf", true, false, true)
	vim.api.nvim_feedkeys(keys, "m", false)
end)

vim.keymap.set("n", "zc", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
	-- queue zf after the selection feedkeys have been processed
	local keys = vim.api.nvim_replace_termcodes("zf", true, false, true)
	vim.api.nvim_feedkeys(keys, "m", false)
end)
