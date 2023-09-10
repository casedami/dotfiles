-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move down", silent = true })
vim.keymap.set("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move up", silent = true })
