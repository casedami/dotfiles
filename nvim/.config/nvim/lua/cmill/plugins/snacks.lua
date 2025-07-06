return {
    {
        "folke/snacks.nvim",
        lazy = false,
        opts = {
            statuscolumn = {
                enabled = true,
                left = { "git" },
                right = { "sign", "fold", "mark" },
            },
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
                        .. vim.uv.cwd():gsub("^/home/$USER", "~")
                        .. "\non "
                        .. os.date("%a %B %d %Y"),
          -- stylua: ignore
          keys = {
            { icon = " ", key = "f", desc = "find file", action = "<leader>ff" },
            { icon = " ", key = "r", desc = "recent files", action = "<leader>fr" },
            { icon = "󱏒 ", key = "e", desc = "explorer", action = "<leader>fe" },
            { icon = " ", key = "g", desc = "grep", action = "<leader>fg" },
            -- { icon = " ", key = "s", desc = "restore session", action = ":Sesh load", enabled = require("sesh").exists() },
            { icon = " ", key = "c", desc = "config", action = "<leader>fc" },
            { icon = "󰒲 ", key = "l", desc = "lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
            { icon = " ", key = "q", desc = "quit", action = ":qa!" },
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
        -- stylua: ignore
        keys = {
            -- explorer
            { "<leader>fe", function() Snacks.explorer.open() end, desc = "open file explorer" },
            -- picker.files
            { "<leader>ff", function() Snacks.picker.smart() end, desc = "search files" },
            { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "search config files" },
            { "<leader>fr", function() Snacks.picker.recent() end, desc = "search recent files"  },
            { "<leader>f,", function() Snacks.picker.buffers() end, desc = "search open buffers" },
            { "<leader>fg", function() Snacks.picker.grep() end, desc = "grep" },
            { "<leader>fG", function() Snacks.picker.grep_word() end, desc = "grep under cursor" },
            { "<leader>ft", function() Snacks.picker.grep({ search = "(TODO|BUG|FIXME|WARN|NOTE|MARK):" }) end, desc = "find TODO items" },
            -- picker.vim
            { "<leader>fh", function() Snacks.picker.help() end, desc = "search help" },
            { "<leader>fC", function() Snacks.picker.colorschemes() end, desc = "search colorschemes" },
            { "<leader>fH", function() Snacks.picker.highlights() end, desc = "search highlights" },
            { "<leader>f:", function() Snacks.picker.command_history() end, desc = "search command history" },
            { "<leader>f/", function() Snacks.picker.search_history() end, desc = "search search history" },
            { "<leader>f\"", function() Snacks.picker.registers() end, desc = "search registers" },
            { "<leader>fm", function() Snacks.picker.marks() end, desc = "search marks" },
            -- picker.git
            { "<leader>gs", function() Snacks.picker.git_status() end, desc = "open git status" },
            { "<leader>gl", function() Snacks.picker.git_log() end, desc = "open git log" },
            { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "open git diff" },
            -- picker.lsp
            { "gd", function() Snacks.picker.lsp_definitions() end, desc = "show/goto definition(s)" },
            { "gD", function() Snacks.picker.lsp_declarations() end, desc = "show/goto declaration(s)" },
        },
    },
}
