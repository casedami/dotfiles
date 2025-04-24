local map = vim.keymap.set

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
        local opts = { buffer = bufnr }
        map("n", "<leader>lr", vim.lsp.buf.rename, opts)
        map({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, opts)
        map("n", "<leader>D", vim.diagnostic.open_float, opts)
        map("n", "<leader>dd", toggle_diagnostics, opts)
        map("n", "<leader>lh", vim.lsp.buf.document_highlight, opts)

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
        map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
        map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
        map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
        map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
        map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
        map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })
    end,
})
