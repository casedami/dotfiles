-- delete a-zA-Z marks
vim.api.nvim_create_user_command("DM", function()
    vim.cmd("delm a-zA-Z")
    vim.notify("deleting marks...", vim.log.levels.INFO, {})
end, {})

-- grep for todo items
vim.api.nvim_create_user_command("Todo", function()
    vim.cmd(
        [[ lua require("fzf-lua").live_grep({no_esc=true, search="(TODO|BUG|FIXME|WARN|NOTE|MARK)"}) ]]
    )
end, { desc = "Grep TODOs", nargs = 0 })

-- open typst preview
vim.api.nvim_create_user_command("CC", function()
    vim.cmd("TypstPreview")
end, { nargs = 0 })
