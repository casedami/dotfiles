require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

require("mason-lspconfig").setup({
    ensure_installed = {
		"black",
		"pyright",
		"mypy",
		"ruff",
		"debugpy",
		"lua-language-server",
	}
})
