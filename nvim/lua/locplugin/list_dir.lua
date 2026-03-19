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
	local result = {
		---@type table<string[]>
		dirs = {},
		---@type table<string[]>
		files = {},
	}

	local dirs = vim.fn.systemlist(string.format("cd %s; ls -a | where type == dir | get name | to text", dir))
	result.dirs = vim.tbl_map(function(s)
		return s .. "/"
	end, dirs)

	---@type table<string[]>
	result.files = vim.fn.systemlist(string.format("cd %s; ls -a | where type == file | get name | to text", dir))
	return result
end

local function list_dir(cwd)
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
vim.keymap.set("n", "<leader>fe", function() list_dir(vim.fn.getcwd()) end, { desc = "Directory: list current working directory" })
vim.keymap.set("n", "<leader>fE", function() list_dir(vim.fn.expand("%:p:h")) end, { desc = "Directory: list current buffer's directory" })

vim.api.nvim_create_autocmd({"ShellCmdPost", "BufWritePost"}, {
	group = vim.api.nvim_create_augroup("casedami/invalidate_list_dir_cache", { clear = true }),
  desc = "Invalidate cache after a shell cmd",
  callback= function()
    cache = {}
  end
})
