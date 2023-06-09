function setColor(color)
	color = color or "catppuccin"
	vim.cmd.colorscheme(color)
end

setColor()
