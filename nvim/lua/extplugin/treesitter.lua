local ts = require("nvim-treesitter")

ts.install({
    "bash",
    "c",
    "comment",
    "gitcommit",
    "gitignore",
    "git_config",
    "json",
    "lua",
    "markdown",
    "markdown_inline",
    "python",
    "regex",
    "rust",
    "sql",
    "toml",
    "typst",
    "vim",
    "vimdoc",
    "yaml",
})

local group = vim.g.utils.augroup("treesitter_setup")
local ignore_filetypes = {
    "checkhealth",
}

vim.api.nvim_create_autocmd("FileType", {
    group = group,
    desc = "Enable treesitter highlighting and indentation",
    callback = function(event)
        if vim.tbl_contains(ignore_filetypes, event.match) then
            return
        end

        local lang = vim.treesitter.language.get_lang(event.match) or event.match
        local buf = event.buf

        pcall(vim.treesitter.start, buf, lang)

        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

        ts.install({ lang })
    end,
})
