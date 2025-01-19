return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = "Neovim [" .. tostring(vim.version()) .. "] in " .. vim.fn
            .getcwd()
            :gsub("^/Users/caseymiller", "~") .. "\non " .. os.date(
            "%a %B %d %Y"
          ),
          -- stylua: ignore
          keys = {
            { icon = " ", key = "f", desc = "find file", action = ":Telescope find_files" },
            { icon = " ", key = "n", desc = "new File", action = ":lua require('cmill.core.util').new_file_prompt()" },
            { icon = " ", key = "r", desc = "recent files", action = ":Telescope oldfiles cwd_only=true" },
            { icon = "󱏒 ", key = "e", desc = "explorer", action = ":Oil" },
            { icon = " ", key = "g", desc = "grep", action = ":Telescope live_grep" },
            { icon = " ", key = "s", desc = "restore session", action = ":SesLoad" },
            { icon = " ", key = "c", desc = "config", action = ":lua require('cmill.core.util').config_files()" },
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
  },
}
