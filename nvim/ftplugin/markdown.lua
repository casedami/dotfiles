vim.keymap.set("n", "<localleader>ll", "<cmd>ObsidianOpen<cr>")
vim.keymap.set("n", "<localleader>gd", "<cmd>ObsidianFollowLink<cr>")
vim.keymap.set("n", "<localleader>ff", "<cmd>ObsidianBacklinks<cr>")
vim.keymap.set("n", "<localleader>t", "<cmd>ObsidianTemplate<cr>")
vim.opt.foldmethod = "syntax"
vim.opt.foldenable = true
vim.opt.spelllang = {}
vim.opt.signcolumn = "no"
-- vim.opt.textwidth = 88
-- vim.opt.formatoptions = { "autowrap" }
-- vim.cmd("set fo+=a")
