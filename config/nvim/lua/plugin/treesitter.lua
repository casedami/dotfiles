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
ts.install(vim.iter(vim.tbl_values(ft_parsers)):flatten():totable())

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

local fold_ts_obj = function(obj)
	require("nvim-treesitter-textobjects.select").select_textobject(("@%s.outer"):format(obj), "textobjects")
	local keys = vim.api.nvim_replace_termcodes("zf", true, false, true)
	vim.api.nvim_feedkeys(keys, "m", false)
end

local select = require("nvim-treesitter-textobjects.select")
local move = require("nvim-treesitter-textobjects.move")

-- stylua: ignore start
vim.keymap.set({ "x", "o" }, "af", function() select.select_textobject("@function.outer", "textobjects") end)
vim.keymap.set({ "x", "o" }, "if", function() select.select_textobject("@function.inner", "textobjects") end)
vim.keymap.set({ "x", "o" }, "ac", function() select.select_textobject("@class.outer", "textobjects") end)
vim.keymap.set({ "x", "o" }, "ic", function() select.select_textobject("@class.inner", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "]f", function() move.goto_next_start("@function.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "]c", function() move.goto_next_start("@class.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "]l", function() move.goto_next_start({ "@loop.inner", "@loop.outer" }, "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "]F", function() move.goto_next_end("@function.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "]C", function() move.goto_next_end("@class.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "[f", function() move.goto_previous_start("@function.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "[c", function() move.goto_previous_start("@class.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "[F", function() move.goto_previous_end("@function.outer", "textobjects") end)
vim.keymap.set({ "n", "x", "o" }, "[C", function() move.goto_previous_end("@class.outer", "textobjects") end)
vim.keymap.set("n", "zm", function() fold_ts_obj("function") end)
vim.keymap.set("n", "zc", function() fold_ts_obj("class") end)
-- stylua: ignore end
