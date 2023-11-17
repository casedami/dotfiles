vim.keymap.set("n", "<localleader>ll", "<cmd>ObsidianOpen<cr>")
vim.keymap.set("n", "<localleader>gd", "<cmd>ObsidianFollowLink<cr>")
vim.keymap.set("n", "<localleader>ff", "<cmd>ObsidianBacklinks<cr>")
vim.keymap.set("n", "<localleader>t", "<cmd>ObsidianTemplate<cr>")
vim.opt.spelllang = {}
vim.opt.statuscolumn = "%=%{v:relnum?v:relnum:v:lnum}  " -- build statuscolumn
