return {
  {
    "echasnovski/mini.starter",
    version = "*",
    event = "VimEnter",
    opts = function()
      local pad = string.rep(" ", 22)
      local new_section = function(name, action, section)
        return { name = name, action = action, section = pad .. section }
      end
      local starter = require("mini.starter")
      local config = {
        evaluate_single = true,
        content_hooks = {
          starter.gen_hook.aligning("center", "center"),
        },
        items = {
          new_section("Explorer", "Oil", ""),
          new_section("Files", "Telescope find_files", "Telescope"),
          new_section("Recents", "Telescope oldfiles cwd_only=true", "Telescope"),
          new_section("Grep", "Telescope live_grep", "Telescope"),
          new_section("Lazy", "Lazy", "Built-in"),
          new_section("Quit", "qa", "Built-in"),
        },
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
          starter.config.footer = "⚡ Neovim loaded "
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
