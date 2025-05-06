return {
    {
        "folke/snacks.nvim",
        lazy = false,
        opts = {
            statuscolumn = { enabled = true },
            explorer = { enabled = true },
            -- indent = { enabled = true },
            picker = {
                layout = {
                    layout = {
                        backdrop = false,
                    },
                },
                icons = {
                    files = {
                        enabled = false,
                    },
                },
                sources = {
                    command_history = {
                        layout = {
                            preview = false,
                            preset = "vertical",
                        },
                    },
                    search_history = {
                        layout = {
                            preview = false,
                            preset = "vertical",
                        },
                    },
                    registers = {
                        layout = {
                            preview = false,
                            preset = "vertical",
                        },
                    },
                    recent = {
                        filter = { cwd = true },
                    },
                    explorer = { hidden = true, ignored = true },
                },
            },
            dashboard = {
                enabled = true,
                preset = {
                    header = "Neovim ["
                        .. tostring(vim.version())
                        .. "] in "
                        .. vim.uv.cwd():gsub("^/Users/caseymiller", "~")
                        .. "\non "
                        .. os.date("%a %B %d %Y"),
          -- stylua: ignore
          keys = {
            { icon = " ", key = "f", desc = "find file", action = "<leader>ff" },
            { icon = " ", key = "r", desc = "recent files", action = "<leader>fr" },
            { icon = "󱏒 ", key = "e", desc = "explorer", action = "<leader>fe" },
            { icon = " ", key = "g", desc = "grep", action = "<leader>fg" },
            { icon = " ", key = "G", desc = "git", action = ":Neogit", enabled = require("cmill.core.util").show_diff()},
            -- { icon = " ", key = "s", desc = "restore session", action = ":SesLoad", enabled = require("cmill.core.session").session_exists() },
            { icon = " ", key = "c", desc = "config", action = "<leader>fc" },
            { icon = "󰒲 ", key = "l", desc = "lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
            { icon = " ", key = "q", desc = "quit", action = ":qa" },
          },
                },
                sections = {
                    { section = "header" },
                    { section = "keys", gap = 1, padding = 1 },
                    {
                        pane = 2,
                        icon = " ",
                        title = "Recent Files",
                        section = "recent_files",
                        indent = 2,
                        padding = 2,
                    },
                    {
                        pane = 2,
                        icon = " ",
                        title = "Projects",
                        section = "projects",
                        indent = 2,
                        padding = 2,
                    },
                    {
                        pane = 2,
                        icon = " ",
                        title = "Git Status",
                        section = "terminal",
                        enabled = function()
                            return Snacks.git.get_root() ~= nil
                        end,
                        cmd = "git status --short --branch --renames",
                        height = 5,
                        padding = 1,
                        ttl = 5 * 60,
                        indent = 3,
                    },
                    { section = "startup" },
                },
            },
        },
        keys = function()
      -- stylua: ignore
      K = {
        -- explorer
        { "<leader>fe", function() Snacks.explorer.open() end, desc = "Open file explorer" },
        -- picker.files
        { "<leader>ff", function() Snacks.picker.smart() end, desc = "Files" },
        { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Config files" },
        { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent files"  },
        { "<leader>f,", function() Snacks.picker.buffers() end, desc = "Buffers" },
        { "<leader>fg", function() Snacks.picker.grep() end, desc = "Grep" },
        { "<leader>fG", function() Snacks.picker.grep_word() end, desc = "Grep under cursor" },
        { "<leader>ft", function() Snacks.picker.grep({ search = "(TODO|BUG|FIXME|WARN|NOTE):" }) end, desc = "Find TODO items" },
        -- picker.vim
        { "<leader>fh", function() Snacks.picker.help() end, desc = "Help" },
        { "<leader>fC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
        { "<leader>fH", function() Snacks.picker.highlights() end, desc = "Highlights" },
        { "<leader>f:", function() Snacks.picker.command_history() end, desc = "Command history" },
        { "<leader>f/", function() Snacks.picker.search_history() end, desc = "Search history" },
        { "<leader>fs", function() Snacks.picker.registers() end, desc = "Registers" },
        { "<leader>fm", function() Snacks.picker.marks() end, desc = "Marks" },
        -- picker.git
        { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git status" },
        { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git log" },
        { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git diff" },
        { "<leader>fd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
        { "<leader>fD", function() Snacks.picker.diagnostics_buffer() end, desc = "Diagnostics for current buffer" },
        -- picker.lsp
        { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
        { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
        { "<leader>lR", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
        { "<leader>lI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
        { "<leader>lt", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto Type Definition" },
        { "<leader>ls", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
        { "<leader>lS", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
      }
            return K
        end,
    },
}
