vim.keymap.set("", "<leader>fo", function()
    require("conform").format({ async = true, lsp_fallback = true })
end)

vim.api.nvim_create_user_command("DelMarks", function()
    vim.cmd("delm a-zA-Z")
    vim.notify("deleting marks...", vim.log.levels.INFO, {})
end, {})

vim.api.nvim_create_user_command("SesWrite", function()
    require("cmill.core.session").save_session()
end, {})
vim.api.nvim_create_user_command("SesDel", function()
    require("cmill.core.session").delete_session()
end, {})

vim.api.nvim_create_user_command("SesDelA", function()
    require("cmill.core.session").delete_all_sessions()
end, {})

vim.api.nvim_create_user_command("SesLoad", function()
    require("cmill.core.session").load_session()
end, {})

local new_file = function(comm, fname)
    local path = vim.fn.expand("%:p:h")
    local is_note = path:find("self/notes")

    if is_note then
        path = vim.fn.expand("~") .. "/self/notes/main/_inbox"
    end

    vim.cmd(("%s %s"):format(comm, path .. "/" .. fname))
end

vim.api.nvim_create_user_command("New", function(inp)
    new_file("edit", inp.args)
end, { nargs = 1 })

vim.api.nvim_create_user_command("NewSplit", function(inp)
    new_file("sp", inp.args)
end, { nargs = 1 })

vim.api.nvim_create_user_command("NewVsplit", function(inp)
    new_file("vsp", inp.args)
end, { nargs = 1 })

vim.api.nvim_create_user_command("Todo", function()
    Snacks.picker.grep({ search = "(TODO|BUG|FIXME|WARN|NOTE):" })
end, { desc = "Grep TODOs", nargs = 0 })
