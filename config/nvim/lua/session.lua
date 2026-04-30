local function get_root()
	local root = vim.fs.root(vim.fn.expand("%"), ".git")
	if root == nil then
		vim.notify("Session error: not in a git repository", vim.log.levels.ERROR)
		return nil
	end
	return root
end

local function get_session_path(root)
	vim.fn.mkdir(vim.g.sessions_dir, "p")
	return vim.fs.joinpath(vim.g.sessions_dir, vim.fn.sha256(root) .. ".vim")
end

vim.api.nvim_create_user_command("Save", function()
	local root = get_root()
	if root == nil then
		return
	end
	vim.cmd("mksession! " .. get_session_path(root))
end, { desc = string.format("Save a session file in %s/<root-hash>.vim", vim.g.sessions_dir), nargs = 0 })

vim.api.nvim_create_user_command("Load", function()
	local root = get_root()
	if root == nil then
		return
	end
	local ok, _ = pcall(vim.cmd, "source " .. get_session_path(root))
	if not ok then
		vim.notify(string.format("No session found for '%s'", root), vim.log.levels.INFO)
	end
end, { nargs = 0 })

vim.api.nvim_create_user_command("Del", function()
	local root = get_root()
	if root == nil then
		return
	end
	local ok, _ = pcall(vim.fs.rm, get_session_path(root))
	if ok then
		vim.notify("Successfully deleted session for " .. root)
	else
		vim.notify("Error deleting session for " .. root)
	end
end, { nargs = 0 })
