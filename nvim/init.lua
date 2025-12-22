vim.pack.add({
    "https://github.com/j-hui/fidget.nvim",
    "https://github.com/casedami/session.nvim",
    "https://github.com/casedami/heron.nvim",
    "https://github.com/casedami/neomodern.nvim",
    "https://github.com/nvim-mini/mini.icons",
    { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
    "https://github.com/ibhagwan/fzf-lua",
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
    "https://github.com/stevearc/conform.nvim",
})

-- Load globals and vim opts first
require("globals")
require("options")

-- Load everything else
vim.g.utils.import_cfg("locplugin")
vim.g.utils.import_cfg("extplugin")
