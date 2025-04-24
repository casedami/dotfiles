local blink = require("blink.cmp")
return {
    cmd = { "tinymist" },
    filetypes = { "typst" },
    settings = {
        ["tinymist.preview.background.enabled"] = true,
        formatterMode = "typstyle",
        formatterPrintWidth = 79,
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
