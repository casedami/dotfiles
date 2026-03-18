local keymaps = {
    { key = "f", cmd = "<cmd>FzfLua files<cr>" },
    { key = "r", cmd = "<cmd>FzfLua oldfiles<cr>" },
    { key = "g", cmd = "<cmd>FzfLua live_grep<cr>" },
    { key = "s", cmd = "<cmd>Session select<cr>" },
    { key = "qq", cmd = "<cmd>q!<cr>" },
}

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        if vim.fn.argc() ~= 0 then
            return
        end

        vim.api.nvim_set_option_value("modifiable", false, { buf = 1 })
        for _, m in ipairs(keymaps) do
            vim.keymap.set("n", m.key, m.cmd, { buffer = true, nowait = true })
        end
    end,
    once = true,
})
