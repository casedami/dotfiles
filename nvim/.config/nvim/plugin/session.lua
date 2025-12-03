vim.api.nvim_create_user_command("SessionSave", function(opts)
    require("self.session.plugin").save(opts.args)
end, { nargs = "*" })

vim.api.nvim_create_user_command("SessionList", function()
    require("self.session.plugin").list()
end, { nargs = 0 })

vim.api.nvim_create_user_command("SessionLoad", function()
    require("self.session.plugin").select()
end, { nargs = 0 })

vim.api.nvim_create_user_command("SessionDelete", function(opts)
    require("self.session.plugin").try_delete(opts.args)
end, { nargs = "*" })

vim.api.nvim_create_user_command("SessionSync", function()
    require("self.session.plugin").sync()
end, { nargs = 0 })

vim.keymap.set("c", "SS", "SessionSave")
vim.keymap.set("c", "SL", "SessionLoad")
