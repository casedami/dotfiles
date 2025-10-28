return {
    "mikavilpas/yazi.nvim",
    lazy = false,
    cmd = "Yazi",
    config = function()
        require("yazi").setup({
            open_for_directories = true,
        })
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
