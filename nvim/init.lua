vim.pack.add({
    "https://github.com/j-hui/fidget.nvim",
    "https://github.com/casedami/session.nvim",
    "https://github.com/casedami/heron.nvim",
    "https://github.com/casedami/neomodern.nvim",
    "https://github.com/lewis6991/gitsigns.nvim",
    { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
    "https://github.com/ibhagwan/fzf-lua",
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
    "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
    "https://github.com/stevearc/conform.nvim",
    "https://github.com/chomosuke/typst-preview.nvim",
    "https://github.com/nvim-lualine/lualine.nvim",
})

require("neomodern").setup({
    theme = "moon",
    gutter = {
        cursorline = true,
    },
    overrides = {
        default = {
            constant = "#889ab8",
            line = "#19191e",
        },
    },
})
require("neomodern").load()

-- Load main config first
require("globals")
require("options")
require("keymaps")
require("autocmds")
require("lsp")

-- Load everything else
vim.g.utils.import_cfg("locplugin")
vim.g.utils.import_cfg("extplugin")

require("typst-preview").setup({ invert_colors = "auto" })
require("gitsigns").setup({})
