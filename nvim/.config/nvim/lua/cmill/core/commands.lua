-- grep for todo items
vim.api.nvim_create_user_command("Todo", function()
    vim.cmd(
        [[ lua require("fzf-lua").live_grep({no_esc=true, search="(TODO|BUG|FIXME|WARN|NOTE|MARK)"}) ]]
    )
end, { desc = "Grep TODOs", nargs = 0 })

local function find_session_files(limit)
    return vim.fs.find({ "Session.vim" }, { limit = limit, type = "file" })
end

vim.api.nvim_create_user_command("LoadSessionQuiet", function()
    local sfiles = find_session_files({ limit = 1 })
    if #sfiles == 1 then
        vim.cmd(string.format("source %s", sfiles[1]))
    end
end, { nargs = 0 })

vim.api.nvim_create_user_command("DelSessionQuiet", function(opts)
    local limit = opts.bang and math.huge or nil
    local sfiles = find_session_files({ limit = limit })
    for _, s in ipairs(sfiles) do
        vim.fs.rm(s)
    end
end, { bang = true })

vim.api.nvim_create_user_command("Commit", function()
    local template_path =
        vim.fn.system("git config --get commit.template"):gsub("\n", "")
    template_path = vim.fn.expand(template_path)
    local template = ""
    if vim.fn.filereadable(template_path) == 1 then
        template = vim.fn.readfile(template_path)
    end

    vim.cmd(string.format("%snew", #template))
    vim.api.nvim_buf_set_lines(0, 0, -1, false, template)
    vim.bo.buftype = "nofile"
    vim.bo.filetype = "gitcommit"

    vim.keymap.set("n", "<c-c>", function()
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        local tmpfile = vim.fn.tempname()
        vim.fn.writefile(lines, tmpfile)

        local result = vim.fn.system("git commit -F " .. vim.fn.shellescape(tmpfile))

        vim.fn.delete(tmpfile)
        vim.cmd("bd")

        if vim.v.shell_error == 0 then
            vim.notify("Commit successful!", vim.log.levels.INFO)
        else
            vim.notify("Commit failed: " .. result, vim.log.levels.ERROR)
        end
    end, { buffer = 0, desc = "Commit and close" })

    vim.keymap.set("n", "q", function()
        vim.cmd("bd")
    end, { buffer = 0, desc = "Close" })

    vim.cmd("normal! gg")
end, {})
