return {
    cmd = { "ruff", "server", "--preview" },
    root_markers = { ".venv" },
    filetypes = { "python" },
    on_attach = function(client, _)
        if client.name == "ruff_lsp" then
            -- Disable hover in favor
            client.server_capabilities.hoverProvider = false
        end
    end,
}
