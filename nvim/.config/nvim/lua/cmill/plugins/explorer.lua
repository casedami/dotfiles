return {
    "mikavilpas/yazi.nvim",
    lazy = false,
    cmd = "Yazi",
    opts = {
        open_for_directories = true,
    },
    config = function()
        -- stylua: ignore start
        vim.keymap.set("n", "<leader>fe", "<cmd>Yazi<cr>", { desc = "Explorer: open at the current file" })
        vim.keymap.set("n", "<leader>fE", "<cmd>Yazi cwd<cr>", { desc = "Explorer: open in cwd" })
        vim.keymap.set("n", "<C-p>", "<cmd>Yazi toggle<cr>", { desc = "Explorer: resume" })
        -- stylua: ignore end
    end,
    init = function()
        vim.g.loaded_netrwPlugin = 1
    end,
}
