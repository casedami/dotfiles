-- stylua: ignore start
local map = vim.keymap.set

-- lazy
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Open Lazy", silent = true })

-- help
map("n", "<leader>?", "<cmd>h selfhelp<cr>", { desc = "Open self help", silent = true })
map("n", "<localleader>?", ":h self-", { desc = "Start self help command" })

-- move line up/down
map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move down", silent = true })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move up", silent = true })

local function del_marks()
  vim.cmd("delm a-zA-Z")
  vim.cmd("wviminfo!")
  vim.cmd(([[echohl DiagnosticInfo | echomsg "%s" | echohl None]]):format(" deleting marks..."))
end

-- marks
map( "n", "<leader>dm", function() del_marks() end, { desc = "Delete marks", silent = true })
vim.api.nvim_create_user_command("M", "marks", { desc = "Show marks" })

-- remove highlighting after search
map("n", "<CR>", "<cmd>noh<cr><cr>", { desc = "Remove highlighting after seach", remap = false })

-- paste from 0 register
map({"n", "v"}, ")", "\"0p")
map({"n", "v"}, "(", "\"0P")

-- remap q to history
map("n", "q", "q:") -- commnad history
map("n", "Q", "q/") -- search history

map("n", "!", "<C-l>") -- clear cmd line output

-- auto center when moving up/down
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- edit shortcuts
map("n", "<localleader>e", ":e <C-R>=expand('%:p:h') . '/' <CR>", { desc = "Edit file in current directory" })
map("n", "<localleader>es", ":sp <C-R>=expand('%:p:h') . '/' <CR>", { desc = "Edit file in current directory (horizonatal split)" })
map("n", "<localleader>ev", ":vsp <C-R>=expand('%:p:h') . '/' <CR>", { desc = "Edit file in current directory (vertical split)" })

-- search
map("n", "<localleader>s", ":s/", { desc = "Start search and replace" })
map("n", "<localleader>S", ":%s/", { desc = "Start global search and replace" })

-- remap in-line movement
map("n", "0", "^", { desc = "Goto beginning of line" })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- buffers
map("n", "<localleader>]", "<cmd>bnext<cr>", { desc = "Next buffer in bufferlist" })
map("n", "<localleader>[", "<cmd>bprev<cr>", { desc = "Previous buffer in bufferlist" })
map("n", "<localleader>bd", "<cmd>bd<cr>", { desc = "Delete buffer" })
map("n", "<localleader>p", "<C-6>", { desc = "Previous buffer" })

-- tabs
map("n", "<localleader>}", "<cmd>tabnext<cr>", { desc = "Next tab" })
map("n", "<localleader>{", "<cmd>tabprevious<cr>", { desc = "Previous tab" })
map("n", "<localleader><tab>c", "<cmd>tabnew %<cr>", { desc = "New tab" })
map("n", "<localleader><tab>d", "<cmd>tabclose<cr>", { desc = "Close tab" })

-- windows
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize +2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize -2<cr>", { desc = "Increase window width" })
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete window", remap = true })
map("n", "<leader>-", "<C-W>s", { desc = "Split window below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split window right", remap = true })
map("n", "<leader>we", "<C-W>=", { desc = "Size windows equally", remap = true })
map("n", "<leader>wk", "<C-W>_", { desc = "Maximize current window vertically", remap = true })
map("n", "<leader>wl", "<C-W>|", { desc = "Maximize current window horizontally", remap = true })

-- quickfix
map("n", "<leader>qn", "<cmd>cnext<cr>", { desc = "Advance to next item" })
map("n", "<leader>qN", "<cmd>cnfile<cr>", { desc = "Advance to first item in next file" })
map("n", "<leader>qp", "<cmd>cprev<cr>", { desc = "Advance to previous item" })
map("n", "<leader>qP", "<cmd>cpfile<cr>", { desc = "Advance to last item in previous file" })
map("n", "<leader>qo", "<cmd>copen<cr>", { desc = "Open quickfix list" })
map("n", "<leader>qc", "<cmd>copen<cr>", { desc = "Close quickfix list" })

-- colorscheme light/dark
local toggle_colscheme = function()
  if vim.o.background == "light" then
    vim.opt.background = "dark"
    vim.g.everforest_background = "hard"
    vim.cmd("colorscheme everforest")
  else
    vim.opt.background = "light"
    vim.g.everforest_background = "soft"
    vim.cmd("colorscheme everforest")
  end
end

map("n", "<leader>uc", function() toggle_colscheme() end)

-- colorcolumn
local toggle_colorcolumn = function()
  if vim.o.colorcolumn == "" then
    vim.opt.colorcolumn = "88"
  else
    vim.opt.colorcolumn = ""
  end
end

map("n", "<leader>!", function() toggle_colorcolumn() end)
-- stylua: ignore end
