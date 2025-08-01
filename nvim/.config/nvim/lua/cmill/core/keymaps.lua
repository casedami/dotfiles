local maps = {
    -- stylua: ignore
    movement = {
        { "n", "0", "^", { desc = "remap inline movement (beginning of line)" } },
        { "n", ")", "$", { desc = "remap inline movement (beginning of line)" } },
        { "n", "<C-d>", "<C-d>zz", { desc = "center after page down" } },
        { "n", "<C-u>", "<C-u>zz", { desc = "center after page up" } },
        { "n", "n", "nzzzv", { desc = "center after next item in search" } },
        { "n", "N", "Nzzzv", { desc = "center after prev item in search" } },
        { "v", "J", ":m '>+1<cr>gv=gv", { silent = true, desc = "move line up" } },
        { "v", "K", ":m '<-2<cr>gv=gv", { silent = true, desc = "move line down" } },
        { "v", "<", "<gv", { desc = "stay in visual mode when indenting" } },
        { "v", ">", ">gv", { desc = "stay in visual mode when indenting" } },
        { "c", "<C-k>", "<up>", { desc = "go backwards in cmdline history" } },
        { "c", "<C-j>", "<down>", { desc = "go forwards in cmdline history" } },
    },

    -- stylua: ignore
    buffers = {
        { "n", "<localleader>]", "<cmd>bnext<cr>", { desc = "next buffer in bufferlist" }, },
        { "n", "<localleader>[", "<cmd>bprev<cr>", { desc = "previous buffer in bufferlist" }, },
        { "n", "<localleader>d", "<cmd>bd<cr>", { desc = "delete buffer" } },
        { "n", "<localleader>p", "<C-6>", { desc = "previous buffer" } },
        { "n", "<localleader>P", "<C-w><C-6>", { desc = "previous buffer in hsplit" } },
    },

    -- stylua: ignore
    tabs = {
        { "n", "<localleader>}", "<cmd>tabnext<cr>", { desc = "next tab" } },
        { "n", "<localleader>{", "<cmd>tabprevious<cr>", { desc = "previous tab" } },
        { "n", "<localleader><tab>c", "<cmd>tabnew %<cr>", { desc = "new tab" } },
        { "n", "<localleader><tab>d", "<cmd>tabclose<cr>", { desc = "close tab" } },
    },

    -- stylua: ignore
    windows = {
        { "n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "increase window height" } },
        { "n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "decrease window height" } },
        { "n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "decrease window width" }, },
        { "n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "increase window width" }, },
        { { "n", "v" }, "<C-h>", "<C-w>h", { desc = "goto left window" } },
        { { "n", "v" }, "<C-j>", "<C-w>j", { desc = "goto lower window" } },
        { { "n", "v" }, "<C-k>", "<C-w>k", { desc = "goto upper window" } },
        { { "n", "v" }, "<C-l>", "<C-w>l", { desc = "goto right window" } },
        { "n", "<leader>wd", "<C-W>c", { desc = "delete window" } },
        { "n", "<leader>we", "<C-W>=", { desc = "split windows equally" } },
        { "n", "<leader>wo", "<C-W><C-O>", { desc = "make buffer the only buffer on screen" }, },
        { "n", "<leader>wk", "<C-W>_", { desc = "maximize current window vertically" }, },
        { "n", "<leader>wh", "<C-W>|", { desc = "maximize current window horizontally" }, },
        { "n", "<leader>wK", "<C-W>K", { desc = "change hsplit layout to vsplit" } },
        { "n", "<leader>wH", "<C-W>H", { desc = "change vsplit layout to hsplit" } },
        { "n", "<leader>wr", "<C-W><C-R>", { desc = "rotate window layout (only works row-/column-wise)" }, },
        { "n", "<leader>-", "<C-W>s", { desc = "split window below" } },
        { "n", "<leader>|", "<C-W>v", { desc = "split window right" } },
    },

    -- stylua: ignore
    qf = {
        { "n", "<leader>cn", "<cmd>cnext<cr>zz", { desc = "goto next item in qfix list" } },
        { "n", "<leader>cnf", "<cmd>cnfile<cr>zz", { desc = "goto first item in next file" } },
        { "n", "<leader>cp", "<cmd>cprev<cr>zz", { desc = "goto previous item in qfix list" } },
        { "n", "<leader>cpf", "<cmd>cpfile<cr>zz", { desc = "goto last item in previous file" } },
        { "n", "<leader>co", "<cmd>copen<cr>", { desc = "open qfix list" } },
        { "n", "<leader>cc", "<cmd>cclose<cr>", { desc = "close qfix list" } },
    },

    -- stylua: ignore
    term = {
        { "n", "<leader>tk", "<cmd>split | resize 15 | terminal<cr>i", { desc = "open term in hsplit" }, },
        { "n", "<leader>th", "<cmd>vsplit | terminal<cr>i", { desc = "open term in vsplit" }, },
        { "n", "<leader>T", "<cmd>tabnew | term<cr>i", { desc = "open term in new tab" }, },
        { "t", "<esc>", "<C-\\><C-n>", { desc = "use esc key to switch normal mode from term mode" }, },
        { "t", "<C-v><esc>", "<esc>", { desc = "send esc key to shell" } },
    },

    -- stylua: ignore
    misc = {
        { "n", "<localleader>l", "<cmd>Lazy<cr>", { desc = "open lazy" } },
        { "n", "<localleader>?", "<cmd>h selfhelp.txt<cr>", { desc = "open selfhelp" }, },
        { { "n", "v" }, "<leader>fo", "<cmd>lua require('conform').format()<cr>" },
        { { "n", "v" }, "=", '"0p', { desc = "forward paste from 0 register" } },
        { { "n", "v" }, "+", '"0P', { desc = "backward paste from 0 register" } },
        { "n", "|", "<cmd>normal yygccp<cr>", { desc = "copy current line, comment it, and paste it below" } },
        { "v", "|", "<cmd>normal y`[V`]gc`]p<cr>", { desc = "copy selected line(s), comment it, and paste it below" } },
        { "i", "<C-p>", '<C-o>"0p', { desc = "paste from 0 register in insert mode" } },
        -- { "n", "<C-i>", "<c-i>", { desc = "i>)" } },
        -- { "n", "<tab>", "<nop>", { desc = "i>)" } },
        { "n", "<C-;>", "<c-l>", { desc = "clear cmd line" } },
        { "n", "<C-'>", "<cmd>nohlsearch|diffupdate|normal! <c-l><cR>", { desc = "clear previous search match highlights" } },
        { "n", "go", "<cmd>call append(line('.'),     repeat([''], v:count1))<cr>", { desc = "insert empty newline below" } },
        { "n", "gO", "<cmd>call append(line('.') - 1, repeat([''], v:count1))<cr>", { desc = "insert empty newline above" } },
        { "ca", "nums", "set relativenumber!", { desc = "togggle relative number" } },
        { "ca", "cd.", "cd %:h", { desc = "cwd expansion" } },
    },
}

for _, group in pairs(maps) do
    for _, v in pairs(group) do
        vim.keymap.set(v[1], v[2], v[3], v[4] or {})
    end
end
