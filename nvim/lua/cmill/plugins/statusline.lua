local components = require("cmill.core.util").statusline_components()
return {
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = "saguaro",
          section_separators = { left = "", right = "" },
          component_separators = { left = "", right = "" },
          disabled_filetypes = { "dashboard" },
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
            components.modes,
          },
          lualine_b = {
            components.branch,
          },
          lualine_c = {
            components.filename,
          },
          lualine_x = {
            components.tabs,
            components.progress,
            components.location,
            components.diagnostics,
          },
          lualine_y = {},
          lualine_z = {},
        },
      })
    end,
  },
}
