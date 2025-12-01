vim.api.nvim_create_user_command("SessionSave", function()
    local M = require("session")
    M:try_save()
end, { nargs = 0 })

vim.api.nvim_create_user_command("SessionList", function()
    local M = require("session")
    M:list()
end, { nargs = 0 })

vim.api.nvim_create_user_command("SessionLoad", function()
    local M = require("session")
    M:try_source()
end, { nargs = 0 })

vim.api.nvim_create_user_command("SessionDelete", function(opts)
    local M = require("session")
    M:try_delete(opts.args)
end, { nargs = "*" })

vim.keymap.set("c", "SS", "SessionSave")
vim.keymap.set("c", "SL", "SessionLoad")
