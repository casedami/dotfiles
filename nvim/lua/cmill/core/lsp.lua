vim.lsp.enable({
    "basedpyright",
    "ruff",
    "luals",
    "rust-analyzer",
    "tinymist",
})

vim.diagnostic.config({
    virtual_text = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        border = "rounded",
        source = true,
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = tools.ui.icons.error,
            [vim.diagnostic.severity.WARN] = tools.ui.icons.warning,
            [vim.diagnostic.severity.HINT] = tools.ui.icons.hint,
            [vim.diagnostic.severity.INFO] = tools.ui.icons.info,
        },
        numhl = {
            [vim.diagnostic.severity.ERROR] = "ErrorMsg",
            [vim.diagnostic.severity.WARN] = "WarningMsg",
        },
    },
})
