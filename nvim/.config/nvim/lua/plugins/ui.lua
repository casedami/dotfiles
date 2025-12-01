return {
    { "echasnovski/mini.icons", version = "*" },
    {
        "j-hui/fidget.nvim",
        event = "BufReadPost",
        config = function()
            require("fidget").setup({
                notification = {
                    override_vim_notify = true,
                    window = {
                        winblend = 0,
                    },
                },
            })
            local banned_messages = { "No information available" }
            vim.notify = function(msg, ...)
                for _, banned in ipairs(banned_messages) do
                    if msg == banned then
                        return
                    end
                end
                return require("fidget").notify(msg, ...)
            end
        end,
    },
}
