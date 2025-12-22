vim.lsp.enable({
    "basedpyright",
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
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
        local bufnr = ev.buf

        -- Lsp
        -- stylua: ignore start
        vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { buffer = bufnr, desc = "LSP: rename symbol under cursor" })
        vim.keymap.set({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, { buffer = bufnr, desc = "LSP: code actions" })
        vim.keymap.set("n", "<leader>lh", vim.lsp.buf.document_highlight, { buffer = bufnr, desc = "LSP: highlight symbol under cursor" })
        -- stylua: ignore end

        --If symbol under cursor has been highlighted using <leader>lh, clear highlights
        --once cursor is moved.
        vim.api.nvim_create_autocmd("CursorMoved", {
            callback = vim.lsp.buf.clear_references,
            buffer = bufnr,
            group = "UserLspConfig",
            desc = "Clear All the References",
            once = true,
        })

        -- Diagnostics
        -- stylua: ignore start
        local toggle_diagnostics = function()
            vim.diagnostic.enable(not vim.diagnostic.is_enabled())
        end
        vim.keymap.set("n", "<leader>D", vim.diagnostic.open_float, { buffer = bufnr, desc = "Diagnostic: current line" })
        vim.keymap.set("n", "<leader>ds", toggle_diagnostics, { buffer = bufnr, desc = "Diagnostic: toggle" })
        local djump = function(count)
            return function()
                vim.diagnostic.jump({
                    count = count,
                })
            end
        end
        vim.keymap.set("n", "]d", djump(1), { desc = "Diagnostic: next" })
        vim.keymap.set("n", "[d", djump(-1), { desc = "Diagnostic: prev" })
        -- stylua: ignore start
    end,
})
