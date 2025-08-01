local ns_marks = vim.api.nvim_create_namespace("marksigns_")

local function augroup(name)
    return vim.api.nvim_create_augroup("cmill" .. name, { clear = true })
end

vim.api.nvim_create_autocmd("BufReadPre", {
    group = augroup("lazydevfix"),
    desc = "fix lazydev workspace",
    pattern = {
        "lua",
    },
    callback = function()
        require("lazydev").find_workspace()
    end,
})

vim.api.nvim_create_autocmd("CursorMoved", {
    group = augroup("marksigns"),
    desc = "add marks to signcolumn",
    callback = function()
        local buf = vim.api.nvim_win_get_buf(0)
        local marks = vim.fn.getmarklist(buf)
        vim.api.nvim_buf_clear_namespace(buf, ns_marks, 0, -1)
        vim.list_extend(marks, vim.fn.getmarklist())
        for _, mark in ipairs(marks) do
            if mark.pos[1] == buf and mark.mark:match("[a-zA-Z]") then
                local lnum = mark.pos[2]
                vim.api.nvim_buf_set_extmark(buf, ns_marks, lnum - 1, 0, {
                    id = lnum,
                    sign_text = mark.mark:sub(2),
                    priority = 1,
                    sign_hl_group = "DiagnosticInfo",
                    cursorline_hl_group = "DiagnosticInfo",
                })
            end
        end
    end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup("highlight_yank"),
    desc = "highlight text on yank",
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
    group = augroup("last_loc"),
    desc = "go to last loc when opening buffer",
    callback = function(event)
        local exclude = { "gitcommit" }
        local buf = event.buf
        if
            vim.tbl_contains(exclude, vim.bo[buf].filetype)
            or vim.b[buf].lazyvim_last_loc
        then
            return
        end
        vim.b[buf].lazyvim_last_loc = true
        local mark = vim.api.nvim_buf_get_mark(buf, '"')
        local lcount = vim.api.nvim_buf_line_count(buf)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

vim.api.nvim_create_autocmd("TermOpen", {
    group = augroup("term"),
    desc = "set win opts when opening term buf",
    callback = function()
        vim.opt_local.spell = false
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.signcolumn = "no"
        vim.keymap.set("n", "q", "<cmd>bd!<cr>", { buffer = true })
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    group = augroup("typst"),
    desc = "set win opts when opening typst buf",
    pattern = {
        "typst",
    },
    callback = function()
        vim.opt_local.spell = true
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    group = augroup("rust"),
    desc = "set win opts when opening rust buf",
    pattern = {
        "rust",
    },
    callback = function()
        vim.opt.textwidth = 74
    end,
})

vim.api.nvim_create_autocmd("BufLeave", {
    group = augroup("start"),
    desc = "restore laststatus when leaving starter",
    pattern = "*",
    callback = function()
        if vim.bo.filetype == "ministarter" then
            vim.opt.laststatus = 3
        end
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    group = augroup("close_with_q"),
    desc = "Close with <q>",
    pattern = {
        "git",
        "help",
        "man",
        "qf",
        "query",
    },
    callback = function(args)
        vim.keymap.set("n", "q", "<cmd>quit<cr>", { buffer = args.buf })
    end,
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
        local bufnr = ev.buf
        -- enable completion triggered by <c-x><c-o>
        vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

        local toggle_diagnostics = function()
            vim.diagnostic.enable(not vim.diagnostic.is_enabled())
        end

        -- lsp
        -- stylua: ignore start
        vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { buffer = bufnr, desc = "lsp rename" })
        vim.keymap.set({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, { buffer = bufnr, desc = "show code actions" })
        vim.keymap.set("n", "<leader>D", vim.diagnostic.open_float, { buffer = bufnr, desc = "Open current line diagnostic as float" })
        vim.keymap.set("n", "<leader>dd", toggle_diagnostics, { buffer = bufnr, desc = "toggle diagnostics" })
        vim.keymap.set("n", "<leader>lh", vim.lsp.buf.document_highlight, { buffer = bufnr, desc = "highlight current lsp symbol" })
        -- stylua: ignore end

        vim.api.nvim_create_autocmd("CursorMoved", {
            callback = vim.lsp.buf.clear_references,
            buffer = bufnr,
            group = "UserLspConfig",
            desc = "Clear All the References",
        })

        -- diagnostics
        local diagnostic_goto = function(next, severity)
            local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
            severity = severity and vim.diagnostic.severity[severity] or nil
            return function()
                go({ severity = severity })
            end
        end
        -- stylua: ignore start
        vim.keymap.set("n", "]d", diagnostic_goto(true), { desc = "next diagnostic" })
        vim.keymap.set("n", "[d", diagnostic_goto(false), { desc = "prev diagnostic" })
        vim.keymap.set("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "next error" })
        vim.keymap.set("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "prev error" })
        vim.keymap.set("n", "]w", diagnostic_goto(true, "WARN"), { desc = "next warning" })
        vim.keymap.set("n", "[w", diagnostic_goto(false, "WARN"), { desc = "prev warning" })
        -- stylua: ignore end
    end,
})
