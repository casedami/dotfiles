return {
  {
    "echasnovski/mini.starter",
    version = "*",
    event = "VimEnter",
    opts = function()
      local new_section = function(name, action)
        return { name = name, action = action, section = "" }
      end
      local starter = require("mini.starter")
      local config = {
        evaluate_single = true,
        content_hooks = {
          starter.gen_hook.padding(0, 4),
          starter.gen_hook.aligning("center", "top"),
        },
        items = {
          new_section("Find", "Telescope find_files"),
          new_section("Explorer", "Oil"),
          new_section("New", "lua require('cmill.core.util').new_file()"),
          new_section("Recents", "Telescope oldfiles cwd_only=true"),
          new_section("Grep", "Telescope live_grep"),
          new_section("Session", "SessionManager load_last_session"),
          new_section("Lazy", "Lazy"),
          new_section("Config", require("cmill.core.util").config),
          new_section("Quit", "qa"),
        },
        silent = true,
      }
      return config
    end,
    config = function(_, config)
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "MiniStarterOpened",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      local starter = require("mini.starter")
      starter.setup(config)

      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        callback = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          starter.config.footer = "loaded "
            .. stats.count
            .. " plugins in "
            .. ms
            .. "ms"
          pcall(starter.refresh)
        end,
      })
    end,
  },
}
