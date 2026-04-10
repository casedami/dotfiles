local blink = require("blink.cmp")
return {
	cmd = { "nu", "--lsp" },
	root_markers = { ".git" },
	filetypes = { "nu" },
	settings = {},
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
