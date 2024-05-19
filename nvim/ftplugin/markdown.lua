-- stylua: ignore start
vim.keymap.set("n", "<localleader>e", ":e ~/self/notes/main/inbox/", {buffer = true})
vim.keymap.set("n", "<localleader>ll", "<cmd>ObsidianOpen<cr>", {buffer = true})
vim.keymap.set("n", "<localleader>gd", "<cmd>ObsidianFollowLink<cr>", {buffer = true})
vim.keymap.set("n", "<localleader>gs", "<cmd>ObsidianFollowLink hsplit<cr>", {buffer = true})
vim.keymap.set("n", "<localleader>gv", "<cmd>ObsidianFollowLink vsplit<cr>", {buffer = true})
vim.keymap.set("n", "<localleader>ff", "<cmd>ObsidianBacklinks<cr>", {buffer = true})
vim.keymap.set("n", "<localleader>ft", ":ObsidianTags ", {buffer = true})
vim.keymap.set("n", "<localleader>fn", "<cmd>ObsidianNew<cr>", {buffer = true})
vim.keymap.set("n", "<localleader>t", "<cmd>ObsidianTemplate<cr>", {buffer = true})
-- stylua: ignore end
vim.opt.foldmethod = "syntax"
vim.opt.foldenable = true
vim.opt.spelllang = {}
vim.opt.textwidth = 88
vim.opt.formatoptions = { "autowrap" }
