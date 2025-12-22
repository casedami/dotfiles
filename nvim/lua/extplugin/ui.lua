require("mini.icons").setup()

-- Use fidget for vim.notify
local banned_messages = { "No information available" }
---@diagnostic disable-next-line: duplicate-set-field
vim.notify = function(msg, ...)
    for _, banned in ipairs(banned_messages) do
        if msg == banned then
            return
        end
    end
    return require("fidget").notify(msg, ...)
end
require("fidget").setup({
    notification = {
        override_vim_notify = true,
        window = {
            winblend = 0,
        },
    },
})
