local blink = require("blink.cmp")
return {
	cmd = { "nil" },
	root_markers = { "flake.nix" },
	filetypes = { "nix" },
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
