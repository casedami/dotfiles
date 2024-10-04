local get_actions = function()
  -- stylua: ignore
  local actions = {
    { action = "Telescope find_files", desc = " find file", icon = " ", key = "f", },
    { action = "lua require('cmill.core.util').new_file()", desc = " new file", icon = " ", key = "n", },
    { action = "Telescope oldfiles cwd_only=true", desc = " recent files", icon = " ", key = "r", },
    { action = "Oil", desc = " explorer", icon = "󱏒 ", key = "e", },
    { action = "Telescope live_grep", desc = " grep", icon = " ", key = "g", },
    { action = "Sessionmanager load_current_dir_session", desc = " restore session", icon = " ", key = "s", },
    { action = "lua require('cmill.core.util').config()", desc = " config", icon = " ", key = "c", },
    { action = "Lazy", desc = " lazy", icon = "󰒲 ", key = "l", },
    { action = function() vim.api.nvim_input("<cmd>qa<cr>") end, desc = " quit", icon = " ", key = "q", },
  }

  local path = vim.loop.cwd() .. "/.git"
  local ok, _ = vim.loop.fs_stat(path)
  if ok then
    table.insert(
      actions,
      6,
      { action = "Neogit", desc = " git", icon = " ", key = "G" }
    )
  end
  return actions
end

return {
  {
    "nvimdev/dashboard-nvim",
    lazy = false,
    opts = function()
      local logo = "Neovim ["
        .. tostring(vim.version())
        .. "] by "
        .. vim.uv.os_get_passwd()["username"]
        .. " on "
        .. os.date("%a %B %d %Y")

      logo = string.rep("\n", 8) .. logo .. "\n\n"

      local opts = {
        theme = "doom",
        hide = {
          statusline = true,
        },
        config = {
          header = vim.split(logo, "\n"),
          -- stylua: ignore
          center = get_actions(),
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
