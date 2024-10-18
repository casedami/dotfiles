local toggle_spell = function()
  vim.opt.spell = not (vim.opt.spell:get())
end

local maps = {
  { "n", "<localleader>ss", toggle_spell },
  { "x", "<localleader>=", ":!pandoc -t commonmark_x<cr>" }, -- auto format selected table
  { "ca", "ff", "ObsidianQuickSwitch" },
  { "ca", "ft", "ObsidianTags" },
  { "ca", "fn", "ObsidianNew" },
}

for _, v in pairs(maps) do
  vim.keymap.set(v[1], v[2], v[3], { buffer = true })
end

-- stylua: ignore end
vim.opt.foldmethod = "syntax"
vim.opt.foldenable = true
vim.opt.textwidth = 88
vim.opt.formatoptions = { "autowrap" }
