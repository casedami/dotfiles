local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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

require("lazy").setup({
  spec = {
    { import = "cmill.plugins" },
  },
  defaults = {
    version = false,
  },
  checker = { enabled = true },
  change_detection = {
    enabled = true,
    notify = false,
  },
})

-- Load custom snippets
require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/snippets/" })
