vim.lsp.enable({
	"ty",
	"clangd",
	"luals",
	"ruff",
	"rust-analyzer",
	"tinymist",
	"yamlls",
	"typescript-ls",
})

vim.diagnostic.config({
	virtual_text = {
		prefix = "",
	},
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = true,
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = vim.g.icons.diag.gutter,
			[vim.diagnostic.severity.WARN] = vim.g.icons.diag.gutter,
			[vim.diagnostic.severity.HINT] = vim.g.icons.diag.gutter,
			[vim.diagnostic.severity.INFO] = vim.g.icons.diag.gutter,
		},
		numhl = {
			[vim.diagnostic.severity.ERROR] = "ErrorMsg",
			[vim.diagnostic.severity.WARN] = "WarningMsg",
		},
	},
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("casedami/lsp_attach", {}),
	callback = function(ev)
		local bufnr = ev.buf

    -- lsp
    -- stylua: ignore start
    vim.keymap.set("n", "grc", function()
        vim.lsp.buf.document_highlight()
        vim.api.nvim_create_autocmd("CursorMoved", {
            group = vim.api.nvim_create_augroup("casedami/clear_ref_his", { clear = true }),
            desc = "Clear All the References",
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.clear_references()
            end,
            once = true,
        })
    end, { buffer = bufnr, desc = "LSP: highlight symbol under cursor" })
		-- stylua: ignore end

    -- diagnostics
    -- stylua: ignore start
    local toggle_diagnostics = function()
        vim.diagnostic.enable(not vim.diagnostic.is_enabled())
    end
    vim.keymap.set("n", "grd", vim.diagnostic.open_float, { buffer = bufnr, desc = "Diagnostic: current line" })
    vim.keymap.set("n", "grT", toggle_diagnostics, { buffer = bufnr, desc = "Diagnostic: toggle" })
    local djump = function(count)
        return function()
            vim.diagnostic.jump({
                count = count,
            })
        end
    end
    vim.keymap.set("n", "]d", djump(1), { desc = "Diagnostic: next" })
    vim.keymap.set("n", "[d", djump(-1), { desc = "Diagnostic: prev" })
		-- stylua: ignore end
	end,
})
