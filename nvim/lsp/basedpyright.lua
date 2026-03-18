local blink = require("blink.cmp")
return {
    cmd = { "basedpyright-langserver", "--stdio" },
    root_markers = { ".venv", "requirements.txt" },
    filetypes = { "python" },
    settings = {
        basedpyright = {
            disableOrganizeImports = true,
            analysis = {
                autoImportCompletions = true,
                extraPaths = { "." },
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                typeCheckingMode = "basic",
            },
        },
    },
    handlers = { -- Remove diagnostics, because there's too much
        ["textDocument/publishDiagnostics"] = function() end,
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
