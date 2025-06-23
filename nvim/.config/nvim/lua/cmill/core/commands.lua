vim.keymap.set("", "<leader>fo", function()
    require("conform").format({ async = true, lsp_fallback = true })
end)

vim.api.nvim_create_user_command("DM", function()
    vim.cmd("delm a-zA-Z")
    vim.notify("deleting marks...", vim.log.levels.INFO, {})
end, {})

local function new_file(comm, fname)
    local path = vim.fn.expand("%:p:h")
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
    Snacks.picker.grep({ search = "(TODO|BUG|FIXME|WARN|NOTE|MARK):" })
end, { desc = "Grep TODOs", nargs = 0 })

vim.api.nvim_create_user_command("CC", function()
    vim.cmd("TypstPreview")
end, { nargs = 0 })
