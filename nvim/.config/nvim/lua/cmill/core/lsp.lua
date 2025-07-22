vim.lsp.enable({
    "basedpyright",
    "clangd",
    "luals",
    "ruff",
    "rust-analyzer",
    "tinymist",
    "yamlls",
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
            [vim.diagnostic.severity.ERROR] = tools.ui.icons.diag.gutter,
            [vim.diagnostic.severity.WARN] = tools.ui.icons.diag.gutter,
            [vim.diagnostic.severity.HINT] = tools.ui.icons.diag.hint,
            [vim.diagnostic.severity.INFO] = tools.ui.icons.diag.info,
        },
        numhl = {
            [vim.diagnostic.severity.ERROR] = "ErrorMsg",
            [vim.diagnostic.severity.WARN] = "WarningMsg",
        },
    },
})
