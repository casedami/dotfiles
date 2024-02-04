local function del_marks()
  vim.cmd("delm a-zA-Z")
  vim.cmd("wviminfo!")
  vim.cmd(
    ([[echohl DiagnosticInfo | echomsg "%s" | echohl None]]):format(
      " deleting marks..."
    )
  )
end

local toggle_colorcolumn = function()
  if vim.o.colorcolumn == "" then
    vim.opt.colorcolumn = "88"
  else
    vim.opt.colorcolumn = ""
  end
end

local opts = {
  silent = { silent = true },
  noremap = { remap = false },
  remap = { remap = true },
}

local maps = {
  { "n", "<leader>l", "<cmd>Lazy<cr>", opts["silent"] }, -- open lazy
  { "n", "<leader>?", "<cmd>h selfhelp<cr>", opts["silent"] }, -- open selfhelp
  { "n", "<localleader>?", ":h self-" }, -- start search command
  -- MOVEMENT
  { "n", "0", "^" }, -- remap inline movement (beginning of line)
  { "n", "<C-u>", "<C-u>zz" }, --auto center after moving up
  { "n", "<C-d>", "<C-d>zz" }, -- auto center after moving down
  { "v", "J", ":m '>+1<cr>gv=gv", opts["silent"] }, -- move line up
  { "v", "K", ":m '<-2<cr>gv=gv", opts["silent"] }, -- move line down
  { "v", "<", "<gv" }, -- better indenting
  { "v", ">", ">gv" }, -- better indenting
  -- BUFFERS
  { "n", "<localleader>]", "<cmd>bnext<cr>" }, -- next buffer in bufferlist
  { "n", "<localleader>[", "<cmd>bprev<cr>" }, -- previous buffer in bufferlist
  { "n", "<localleader>bd", "<cmd>bd<cr>" }, -- delete buffer
  { "n", "<localleader>p", "<C-6>" }, -- previous buffer
  -- TABS
  { "n", "<localleader>}", "<cmd>tabnext<cr>" }, -- next tab
  { "n", "<localleader>{", "<cmd>tabprevious<cr>" }, -- previous tab
  { "n", "<localleader><tab>c", "<cmd>tabnew %<cr>" }, -- new tab
  { "n", "<localleader><tab>d", "<cmd>tabclose<cr>" }, -- close tab
  -- WINDOWS
  { "n", "<C-Up>", "<cmd>resize +2<cr>" }, -- increase window height
  { "n", "<C-Down>", "<cmd>resize -2<cr>" }, -- decrease window height
  { "n", "<C-Left>", "<cmd>vertical resize +2<cr>" }, -- decrease window width
  { "n", "<C-Right>", "<cmd>vertical resize -2<cr>" }, -- increase window width
  { "n", "<C-h>", "<C-w>h", opts["remap"] }, -- goto left window
  { "n", "<C-j>", "<C-w>j", opts["remap"] }, -- goto lower window
  { "n", "<C-k>", "<C-w>k", opts["remap"] }, -- goto upper window
  { "n", "<C-l>", "<C-w>l", opts["remap"] }, -- goto right window
  { "n", "<leader>wd", "<C-W>c", opts["remap"] }, -- delete window
  { "n", "<leader>-", "<C-W>s", opts["remap"] }, -- split window below
  { "n", "<leader>|", "<C-W>v", opts["remap"] }, -- split window right
  { "n", "<leader>we", "<C-W>=", opts["remap"] }, -- split windows equally
  { "n", "<leader>wk", "<C-W>_", opts["remap"] }, -- maximize current window vertically
  { "n", "<leader>wh", "<C-W>|", opts["remap"] }, -- maximize current window horizontally
  -- QUICK FIX LIST
  { "n", "<leader>qn", "<cmd>cnext<cr>" }, -- goto to next item in qf list
  { "n", "<leader>qN", "<cmd>cnfile<cr>" }, -- goto to first item in next file
  { "n", "<leader>qp", "<cmd>cprev<cr>" }, -- goto to previous item in qf list
  { "n", "<leader>qP", "<cmd>cpfile<cr>" }, -- goto to last item in previous file
  { "n", "<leader>qo", "<cmd>copen<cr>" }, -- open qf list
  { "n", "<leader>qc", "<cmd>copen<cr>" }, -- close qf list
  -- MISC COMMAND SHORTCUTS
  { "n", "<localleader>e", ":e <C-R>=expand('%:p:h') . '/' <CR>" }, -- edit new file in current dir
  { "n", "<localleader>es", ":sp <C-R>=expand('%:p:h') . '/' <CR>" }, -- edit new file in current dir (hsplit)
  { "n", "<localleader>ev", ":vsp <C-R>=expand('%:p:h') . '/' <CR>" }, --edit new file in current dir (vsplit)
  { "n", "<localleader>s", ":s/" }, -- start search and replace
  { "n", "<localleader>S", ":%s/" }, -- start global search and replace
  { { "n", "v" }, ")", '"0p' }, -- forward paste from 0 register
  { { "n", "v" }, "(", '"0P' }, -- backward paste from 0 register
  { { "n", "v" }, "q", "q:" }, -- remap q to command history
  { { "n", "v" }, "Q", "q/" }, -- remap Q to search history
  { "n", "!", "<C-l>" }, -- clear cmd line
  { "n", "<CR>", "<cmd>noh<cr><cr>", opts["noremap"] }, -- remove highlighting after search
  {
    "n",
    "<leader>!",
    function()
      toggle_colorcolumn()
    end,
  },
  {
    "n",
    "<leader>dm",
    function()
      del_marks()
    end,
    { silent = true },
  },
}

for _, v in pairs(maps) do
  opts = v[4] or {}
  vim.keymap.set(v[1], v[2], v[3], opts)
end
