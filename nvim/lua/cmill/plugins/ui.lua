return {
  { "MunifTanjim/nui.nvim", event = "VeryLazy" },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      local components = require("cmill.core.util").statusline_components()
      local setup = {
        options = {
          icons_enabled = true,
          theme = "neomodern",
          section_separators = { left = "", right = "" },
          -- section_separators = { left = "", right = "" },
          component_separators = { left = "", right = "" },
          disabled_filetypes = { "starter" },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = true,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          },
        },
        sections = {
          lualine_a = {},
          lualine_b = {
            components.tabs,
            components.branch,
          },
          lualine_c = {
            components.nvim_icon,
            components.filename,
          },
          lualine_x = {
            components.lsp,
            components.progress,
            components.location,
            components.diagnostics,
          },
          lualine_y = {
            components.time,
            components.pomodoro,
          },
          lualine_z = {},
        },
        extensions = {
          "man",
        },
      }
      return setup
    end,
  },
}
