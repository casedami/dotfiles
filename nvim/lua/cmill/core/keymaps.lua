local opts = {
    silent = { silent = true },
    noremap = { remap = false },
    remap = { remap = true },
}

local maps = {
    movement = {
        { "n", "0", "^" }, -- remap inline movement (beginning of line)
        { "n", ")", "$" }, -- remap inline movement (beginning of line)
        { "n", "<C-d>", "<C-d>zz" }, -- center after page down
        { "n", "<C-u>", "<C-u>zz" }, -- center after page up
        { "n", "n", "nzzzv" }, -- center after next item in search
        { "n", "N", "Nzzzv" }, -- center after prev item in search
        { "v", "J", ":m '>+1<cr>gv=gv", opts["silent"] }, -- move line up
        { "v", "K", ":m '<-2<cr>gv=gv", opts["silent"] }, -- move line down
        { "v", "<", "<gv" }, -- stay in visual mode when indenting
        { "v", ">", ">gv" }, -- stay in visual mode when indenting
        { "c", "<C-k>", "<up>" }, -- go backwards in cmdline history
        { "c", "<C-j>", "<down>" }, -- go forwards in cmdline history
    },
    buffers = {
        { "n", "<localleader>]", "<cmd>bnext<cr>" }, -- next buffer in bufferlist
        { "n", "<localleader>[", "<cmd>bprev<cr>" }, -- previous buffer in bufferlist
        { "n", "<localleader>d", "<cmd>bd<cr>" }, -- delete buffer
        { "n", "<localleader>p", "<C-6>" }, -- previous buffer
        { "n", "<localleader>P", "<C-w><C-6>" }, -- previous buffer in hsplit
    },
    tabs = {
        { "n", "<localleader>}", "<cmd>tabnext<cr>" }, -- next tab
        { "n", "<localleader>{", "<cmd>tabprevious<cr>" }, -- previous tab
        { "n", "<localleader><tab>c", "<cmd>tabnew %<cr>" }, -- new tab
        { "n", "<localleader><tab>d", "<cmd>tabclose<cr>" }, -- close tab
    },
    windows = {
        { "n", "<C-Up>", "<cmd>resize +2<cr>" }, -- increase window height
        { "n", "<C-Down>", "<cmd>resize -2<cr>" }, -- decrease window height
        { "n", "<C-Left>", "<cmd>vertical resize -2<cr>" }, -- decrease window width
        { "n", "<C-Right>", "<cmd>vertical resize +2<cr>" }, -- increase window width
        { { "n", "v" }, "<C-h>", "<C-w>h", opts["remap"] }, -- goto left window
        { { "n", "v" }, "<C-j>", "<C-w>j", opts["remap"] }, -- goto lower window
        { { "n", "v" }, "<C-k>", "<C-w>k", opts["remap"] }, -- goto upper window
        { { "n", "v" }, "<C-l>", "<C-w>l", opts["remap"] }, -- goto right window
        { "n", "<leader>wd", "<C-W>c", opts["remap"] }, -- delete window
        { "n", "<leader>we", "<C-W>=", opts["remap"] }, -- split windows equally
        { "n", "<leader>wo", "<C-W><C-O>", opts["remap"] }, -- make buffer the only buffer on screen
        { "n", "<leader>wk", "<C-W>_", opts["remap"] }, -- maximize current window vertically
        { "n", "<leader>wh", "<C-W>|", opts["remap"] }, -- maximize current window horizontally
        { "n", "<leader>wK", "<C-W>K", opts["remap"] }, -- change hsplit layout to vsplit
        { "n", "<leader>wH", "<C-W>H", opts["remap"] }, -- change vsplit layout to hsplit
        { "n", "<leader>wr", "<C-W><C-R>", opts["remap"] }, -- rotate window layout (only works row-/column-wise)
        { "n", "<leader>-", "<C-W>s", opts["remap"] }, -- split window below
        { "n", "<leader>|", "<C-W>v", opts["remap"] }, -- split window right
    },
    qf = {
        { "n", "<leader>cn", "<cmd>cnext<cr>zz" }, -- goto next item in qfix list
        { "n", "<leader>cnf", "<cmd>cnfile<cr>zz" }, -- goto first item in next file
        { "n", "<leader>cp", "<cmd>cprev<cr>zz" }, -- goto previous item in qfix list
        { "n", "<leader>cpf", "<cmd>cpfile<cr>zz" }, -- goto last item in previous file
        { "n", "<leader>co", "<cmd>copen<cr>" }, -- open qfix list
        { "n", "<leader>cc", "<cmd>cclose<cr>" }, -- close qfix list
    },
    term = {
        { "n", "<leader>tk", "<cmd>split | resize 15 | terminal<cr>i" }, -- open term in hsplit
        { "n", "<leader>th", "<cmd>vsplit | terminal<cr>i" }, -- open term in vsplit
        { "n", "<leader>T", "<cmd>tabnew | term<cr>i" }, -- open term in new tab
        { "t", "<esc>", "<C-\\><C-n>" }, -- use esc key to switch normal mode from term mode
        { "t", "<C-v><esc>", "<esc>" }, -- send esc key to shell
    },
    files = {
        { "ca", "fn", "New" }, -- edit new file in current dir
        { "ca", "fnh", "NewSplit" }, -- edit new file in current dir (hsplit)
        { "ca", "fnk", "NewVsplit" }, --edit new file in current dir (vsplit)
    },
    sessions = {
        { "ca", "sw", "SesWrite" }, -- save session for cwd
        { "ca", "sd", "SesDel" }, -- delete session for cwd
        { "ca", "sda", "SesDelA" }, -- delete all saved sessions
        { "ca", "sl", "SesLoad" }, -- load session for cwd
    },
    misc = {
        { "n", "<leader>l", "<cmd>Lazy<cr>", opts["silent"] }, -- open lazy
        { "n", "<leader>?", "<cmd>h selfhelp.txt<cr>", opts["silent"] }, -- open selfhelp
        { "ca", "doc", "Neogen", opts["silent"] }, -- generate docstring
        { { "n", "v" }, "=", '"0p' }, -- forward paste from 0 register
        { { "n", "v" }, "+", '"0P' }, -- backward paste from 0 register
        { "i", "<C-p>", '"0p' }, -- paste from 0 register in insert mode
        { "n", "<tab>", "<nop>" }, -- remave tab (alias for <c-i>)
        { "n", "<C-i>", "<c-i>" }, -- restore jump-forward keymap (<c-i>)
        { "n", "<C-;>", "<c-l>" }, -- clear cmd line
        { "n", "<C-'>", "<cmd>nohlsearch|diffupdate|normal! <c-l><cR>" }, -- clear previous search match highlights
        { "n", "go", "<cmd>call append(line('.'),     repeat([''], v:count1))<cr>" }, -- insert empty newline below
        { "n", "gO", "<cmd>call append(line('.') - 1, repeat([''], v:count1))<cr>" }, -- insert empty newline above
        { "ca", "nums", "set relativenumber!", opts["silent"] },
        { "ca", "cd.", "cd %:h" },
        { "ca", "dopen", "DiffviewOpen" },
        { "ca", "dclose", "DiffviewClose" },
    },
}

for _, group in pairs(maps) do
    for _, v in pairs(group) do
        vim.keymap.set(v[1], v[2], v[3], v[4] or {})
    end
end
