local blink = require("blink.cmp")
return {
	cmd = { "ty", "server" },
	root_markers = { ".venv", "requirements.txt" },
	filetypes = { "python" },
	settings = {},
	handlers = {},
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
