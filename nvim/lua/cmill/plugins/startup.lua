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
          starter.gen_hook.padding(0, 8),
          starter.gen_hook.aligning("center", "top"),
        },
        items = {
          new_section("Find", "Telescope find_files"),
          new_section("Explorer", "Oil"),
          new_section("Recents", "Telescope oldfiles cwd_only=true"),
          new_section("Grep", "Telescope live_grep"),
          new_section("Session", "SessionManager load_last_session"),
          new_section("Lazy", "Lazy"),
          new_section("Quit", "qa"),
        },
        silent = true,
      }
      return config
    end,
  },
  {
    "Shatur/neovim-session-manager",
    event = "VimEnter",
    config = function()
      require("session_manager").setup({
        autoload_mode = "disabled",
        autoload_last_session = false,
        autosave_last_session = false,
      })
    end,
  },
}
