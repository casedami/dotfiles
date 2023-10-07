return {
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = "auto",
          section_separators = { left = "", right = " " },
          component_separators = { left = "", right = "" },
          disabled_filetypes = { "neo-tree" },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = false,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          },
        },
        sections = {
          lualine_a = { { "mode", icon = "" } },
          lualine_b = {
            {
              "branch",
              icon = "",
              padding = { left = 2 },
              color = { fg = "#ff9e64" },
              use_mode_colors = false,
            },
            {
              "diff",
              padding = { left = 2, right = 1 },
              diff_color = {
                added = { fg = "#a9b1d6" },
                removed = { fg = "#f7768e" },
              },
            },
          },
          lualine_c = { { "filename", path = 3, padding = { left = 2 } } },
          lualine_x = { "filetype" },
          lualine_y = { "location" },
          lualine_z = { "progress" },
        },
      })
    end,
  },
}
