vim.g.proj_dir = vim.env.HOME .. "/dev"

-- Install lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- General setup
require("globals")
require("options")
require("keymaps")

-- Plugin setup
require("lazy").setup({
    spec = {
        { import = "plugins" },
    },
    defaults = {
        version = false,
    },
    dev = { path = vim.g.proj_dir },
    checker = {
        enabled = false,
        notify = false,
    },
    change_detection = {
        enabled = true,
        notify = false,
    },
    ui = {
        backdrop = 100,
        border = "rounded",
    },
})

-- Post plugin setup
require("lsp")
require("self.statusline")
require("self.gitsigns")
require("marks")
require("buffers")
