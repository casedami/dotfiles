local pad = " "
vim.api.nvim_set_hl(0, "NormalFG", {
	fg = vim.fn.synIDattr(vim.fn.hlID("Normal"), "fg#"),
})
vim.api.nvim_set_hl(0, "NormalFGItalic", {
	fg = vim.fn.synIDattr(vim.fn.hlID("Normal"), "fg#"),
	italic = true,
})

local function hl_str(hl, str)
	return string.format("%%#%s#%s%%*", hl, str)
end

local branch = function()
	return hl_str("WinSeparator", vim.b.gitsigns_head or "")
end

local loc = function()
	if vim.bo.buftype == "terminal" then
		return ""
	end
	local lcount = vim.fn.line("$")
	return lcount > 1 and hl_str("NormalFG", "%p%% of " .. lcount) or ""
end

local path = function()
	local cases = {
		terminal = "shell",
		help = "help",
	}
	if cases[vim.bo.buftype] then
		return hl_str("NormalFGItalic", cases[vim.bo.buftype])
	end
	if cases[vim.bo.filetype] then
		return hl_str("NormalFGItalic", cases[vim.bo.filetype])
	end

	local abs = vim.api.nvim_buf_get_name(0)
	local rel = vim.fn.fnamemodify(abs, ":.")
	local bufname = (rel == abs) and abs or (vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. "/" .. rel)

	local head = vim.fn.fnamemodify(bufname, ":h")
	local display_head = head == "." and "" or head .. "/"

	local bufnr = vim.api.nvim_get_current_buf()
	local readonly = vim.api.nvim_get_option_value("readonly", { buf = bufnr }) and vim.g.icons.readonly or ""
	local nomod = vim.api.nvim_get_option_value("modifiable", { buf = bufnr }) and "" or vim.g.icons.lock
	local modified = vim.api.nvim_get_option_value("modified", { buf = bufnr }) and vim.g.icons.modified or ""

	return table.concat({
		hl_str("NormalFGItalic", display_head),
		hl_str("NormalFGItalic", vim.fn.fnamemodify(bufname, ":t")),
		pad,
		hl_str("NormalFG", modified),
		hl_str("@property", readonly),
		hl_str("@property", nomod),
	})
end

local showcmd = function()
	local out = vim.api.nvim_eval_statusline("%S", {}).str
	local excludes = {
		[":"] = true,
		["j"] = true,
		["k"] = true,
		["zz"] = true,
	}
	if #out == 0 or excludes[out] then
		return ""
	end
	return hl_str("Type", out)
end

local tabs = function()
	local comp = vim.g.icons.neovim
	if vim.api.nvim_eval("len(gettabinfo())") > 1 then
		comp = tostring(vim.fn.tabpagenr())
	end
	return hl_str("@lsp.typemod.keyword.documentation", comp)
end

RenderStatusLine = function()
	return table.concat({
		pad,
		tabs(),
		branch(),
		path(),
		showcmd(),
		"%=",
		vim.diagnostic.status(),
		pad,
		loc(),
		pad,
	}, pad)
end

vim.opt.statusline = "%!v:lua.RenderStatusLine()"
