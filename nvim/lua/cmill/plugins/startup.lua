return {
  {
    "cdmill/dashboard-nvim",
    lazy = false,
    opts = function()
      local logo = "Neovim ["
        .. tostring(vim.version())
        .. "] in "
        .. vim.fn.getcwd():gsub("^/Users/caseymiller", "~")
        .. "\non "
        .. os.date("%a %B %d %Y")

      logo = string.rep("\n", 8) .. logo .. string.rep("\n", 2)

      local opts = {
        theme = "doom",
        hide = {
          statusline = false,
        },
        config = {
          header = vim.split(logo, "\n"),
          center = {
            {
              action = "Telescope find_files",
              desc = " find file",
              icon = " ",
              key = "f",
            },
            {
              action = "lua require('cmill.core.util').new_file_prompt()",
              desc = " new file",
              icon = " ",
              key = "n",
            },
            {
              action = "Telescope oldfiles cwd_only=true",
              desc = " recent files",
              icon = " ",
              key = "r",
            },
            { action = "Oil", desc = " explorer", icon = "󱏒 ", key = "e" },
            {
              action = "Telescope live_grep",
              desc = " grep",
              icon = " ",
              key = "g",
            },
            {
              action = "Neogit",
              desc = " git",
              icon = " ",
              key = "G",
              cond = require("cmill.core.util").is_git_repo(),
            },
            {
              action = "SessionManager load_current_dir_session",
              desc = " restore session",
              icon = " ",
              key = "s",
              cond = require("session_manager").current_dir_session_exists(),
            },
            {
              action = "lua require('cmill.core.util').config_files()",
              desc = " config",
              icon = " ",
              key = "c",
            },
            { action = "Lazy", desc = " lazy", icon = "󰒲 ", key = "l" },
            {
              action = function()
                vim.api.nvim_input("<cmd>qa<cr>")
              end,
              desc = " quit",
              icon = " ",
              key = "q",
            },
          },
          footer = function()
            local stats = require("lazy").stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return {
              "⚡ Neovim loaded "
                .. stats.loaded
                .. "/"
                .. stats.count
                .. " plugins in "
                .. ms
                .. "ms",
            }
          end,
        },
      }

      for _, button in ipairs(opts.config.center) do
        button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
        button.key_format = "  %s"
      end

      -- open dashboard after closing lazy
      if vim.o.filetype == "lazy" then
        vim.api.nvim_create_autocmd("WinClosed", {
          pattern = tostring(vim.api.nvim_get_current_win()),
          once = true,
          callback = function()
            vim.schedule(function()
              vim.api.nvim_exec_autocmds("UIEnter", { group = "dashboard" })
            end)
          end,
        })
      end

      return opts
    end,
  },
}
