return {
  { "MunifTanjim/nui.nvim", lazy = true },
  {
    "karb94/neoscroll.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("neoscroll").setup()
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local components = require("cmill.core.util").statusline_components()
      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = "auto",
          section_separators = { left = "", right = "" },
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
          "oil",
          "man",
          "quickfix",
          "lazy",
          "mason",
          "trouble",
        },
      })
    end,
  },
}
