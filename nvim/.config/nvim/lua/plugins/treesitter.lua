return {
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufRead", "BufNewFile" },
        build = ":TSUpdate",
        cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
        config = function()
            local opts = {
                highlight = {
                    enable = true,
                    disable = { "latex" },
                },
                indent = {
                    enable = true,
                    disable = {
                        "markdown",
                    },
                },
                autotag = { enable = true },
                ensure_installed = {
                    "regex",
                    "bash",
                    "json",
                    "comment",
                    "yaml",
                    "toml",
                    "markdown",
                    "markdown_inline",
                    "latex",
                    "lua",
                    "vim",
                    "vimdoc",
                    "gitignore",
                    "c",
                    "rust",
                    "python",
                    "go",
                    "typst",
                    "sql",
                },
            }
            if type(opts.ensure_installed) == "table" then
                local added = {}
                opts.ensure_installed = vim.tbl_filter(function(lang)
                    if added[lang] then
                        return false
                    end
                    added[lang] = true
                    return true
                end, opts.ensure_installed)
            end
            require("nvim-treesitter.configs").setup(opts)
        end,
    },
}
