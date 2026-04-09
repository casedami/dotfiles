local cache = {}

local function hl_content(cwd, dirs, files)
	local result = {}
	result[1] = { cwd .. "\n\n", "Function" }
	for _, d in ipairs(dirs) do
		result[#result + 1] = { d .. "\n", "String" }
	end

	for _, f in ipairs(files) do
		result[#result + 1] = { f .. "\n", "Normal" }
	end
	return result
end

local function get_dir_contents(dir)
	return {
		---@type table<string[]>
		dirs = vim.fn.systemlist(string.format("cd %s; ls -d */ .*/ 2>/dev/null", dir)),
		---@type table<string[]>
		files = vim.fn.systemlist(string.format("cd %s; ls -pA | grep -v /", dir)),
	}
end

local function ls(cwd)
	local result = {}
	if cache[cwd] ~= nil then
		result = cache[cwd]
	else
		local contents = get_dir_contents(cwd)
		result = hl_content(cwd, contents.dirs, contents.files)
		cache[cwd] = result
	end

	vim.cmd("redraw")
	vim.api.nvim_echo(result, false, {})
end

-- stylua: ignore start
vim.keymap.set("n", "<leader>e", function() ls(vim.fn.getcwd()) end, { desc = "Directory: list current working directory" })
vim.keymap.set("n", "<leader>E", function() ls(vim.fn.expand("%:p:h")) end, { desc = "Directory: list current buffer's directory" })

vim.api.nvim_create_autocmd({"ShellCmdPost", "BufWritePost"}, {
	group = vim.api.nvim_create_augroup("casedami/invalidate_list_dir_cache", { clear = true }),
  desc = "Invalidate cache after a shell cmd",
  callback= function()
    cache = {}
  end
})
