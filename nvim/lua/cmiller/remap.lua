
-- set leader and show file explorer
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", ":NvimTreeToggle<CR>")
vim.keymap.set("n", "<C-f>", ":NvimTreeFocus<CR>")

-- move selected lines up/down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- maintain cursor position when joining
vim.keymap.set("n", "J", "mzJ`z")

-- keep cursor centered when moving page up/down
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- maintain clipboard when pasting
vim.keymap.set("x", "<leader>p", [["_dP]])

-- don't use Q
vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<leader>fm", ":! black % -q <CR>")

vim.keymap.set("n", "<leader>db", ":DapToggleBreakpoint <CR>")

