return {
    "mikavilpas/yazi.nvim",
    lazy = false,
    cmd = "Yazi",
    -- stylua: ignore
    keys = {
        { "<leader>fe", mode = { "n", "v" }, "<cmd>Yazi<cr>", desc = "Open yazi at the current file", },
        { "<leader>fE", "<cmd>Yazi cwd<cr>", desc = "Open yazi in nvim's working directory", },
        { "<C-p>", "<cmd>Yazi toggle<cr>", desc = "Resume the last yazi session", },
    },
    opts = {
        open_for_directories = true,
    },
    init = function()
        vim.g.loaded_netrwPlugin = 1
    end,
}
