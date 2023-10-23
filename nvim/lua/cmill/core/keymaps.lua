-- stylua: ignore start

local map = vim.keymap.set

-- lazy
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Open Lazy", silent = true })

-- move line up/down
map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move down", silent = true })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move up", silent = true })

-- marks
map( "n", "<leader>md", "<cmd>delm a-zA-Z0-9<cr> | <cmd>wviminfo!<cr> | <cmd>echo 'Deleting all marks...'<cr>", { desc = "Delete all marks", silent = true })

-- remove highlighting after search
map("n", "<CR>", "<cmd>noh<cr><cr>", { desc = "Remove highlighting after seach", remap = false })

-- paste from 0 register, override macro key
map({"n", "v"}, "q", "\"0p")
map({"n", "v"}, "Q", "\"0P")

-- auto center when moving up/down
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- open new file in current directory
map("n", "<localleader>e", ":e %:h/", { desc = "Open new file in current directory" })
map("n", "<localleader>E", ":e ~/", { desc = "Open new file in home directory" })

-- search
map("n", "<localleader>s", ":s/", { desc = "Start search and replace" })
map("n", "<localleader>gs", ":%s/", { desc = "Start global search and replace" })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- buffers
map("n", "H", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "L", "<cmd>bnext<cr>", { desc = "Next buffer" })

-- tabs
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- windows
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete window", remap = true })
map("n", "<leader>-", "<C-W>s", { desc = "Split window below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split window right", remap = true })

-- diagnostics
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- colorschme light/dark
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
