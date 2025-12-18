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

-- General setup
require("globals")
require("options")
require("keymaps")
require("lsp")
require("marks")
require("buffers")
require("statusline")
require("gitsigns")
require("splash")
require("list_dir")

-- Use fidget for vim.notify
local banned_messages = { "No information available" }
vim.notify = function(msg, ...)
    for _, banned in ipairs(banned_messages) do
        if msg == banned then
            return
        end
    end
    return require("fidget").notify(msg, ...)
end
require("fidget").setup({
    notification = {
        override_vim_notify = true,
        window = {
            winblend = 0,
        },
    },
})

-- Plugin setup
require("plugins")
