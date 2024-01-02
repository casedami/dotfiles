local components = require("cmill.core.util").statusline_components()

return {
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = require("cmill.core.util").statusline_theme(),
          section_separators = { left = "", right = "" },
          component_separators = { left = "", right = "" },
          disabled_filetypes = { "dashboard", "toggleterm" },
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
          lualine_a = {
            components.nvim_icon,
            components.modes,
          },
          lualine_b = {
            components.spacer,
            components.filename,
            components.filetype,
            components.spacer,
          },
          lualine_c = {
            components.branch,
            components.diff,
            components.diagnostics,
          },
          lualine_x = {
            components.tabs,
            components.progress,
            components.location,
          },
          lualine_y = {},
          lualine_z = {},
        },
      })
    end,
  },
}
