-- Keymaps are automatically loaded on the VeryLazy event

vim.keymap.set("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move down", silent = true })
vim.keymap.set("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move up", silent = true })
vim.keymap.set("n", "<leader>gg", "<nop>")
vim.keymap.set("n", "<leader>gG", "<nop>")
