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
  },
}
