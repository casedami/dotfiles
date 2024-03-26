vim.keymap.set("n", "<localleader>e", ":e ~/self/notes/main/inbox/")
vim.keymap.set("n", "<localleader>ll", "<cmd>ObsidianOpen<cr>")
vim.keymap.set("n", "<localleader>gd", "<cmd>ObsidianFollowLink<cr>")
vim.keymap.set("n", "<localleader>gs", "<cmd>ObsidianFollowLink hsplit<cr>")
vim.keymap.set("n", "<localleader>gv", "<cmd>ObsidianFollowLink vsplit<cr>")
vim.keymap.set("n", "<localleader>ff", "<cmd>ObsidianBacklinks<cr>")
vim.keymap.set("n", "<localleader>ft", ":ObsidianTags ")
vim.keymap.set("n", "<localleader>fn", "<cmd>ObsidianNew<cr>")
vim.keymap.set("n", "<localleader>t", "<cmd>ObsidianTemplate<cr>")
vim.opt.foldmethod = "syntax"
vim.opt.foldenable = true
vim.opt.spelllang = {}
vim.opt.textwidth = 88
vim.opt.formatoptions = { "autowrap" }
