local blink = require("blink.cmp")
return {
	cmd = { "lua-language-server" },
	root_markers = { "stylua.toml" },
	filetypes = { "lua" },
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
			diagnostics = {
				globals = { "vim" },
			},
			hint = {
				enable = true,
				setType = false,
				paramType = true,
				paramName = "Disable",
				semicolon = "Disable",
				arrayIndex = "Disable",
			},
		},
	},
	capabilities = vim.tbl_deep_extend(
		"force",
		{},
		vim.lsp.protocol.make_client_capabilities(),
		blink.get_lsp_capabilities(),
		{
			fileOperations = {
				didRename = true,
				willRename = true,
			},
		}
	),
}
