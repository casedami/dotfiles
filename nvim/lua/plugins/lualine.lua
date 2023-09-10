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
          lualine_a = { "mode" },
          lualine_b = {
            { "branch", icon = "", padding = { left = 2 }, color = { fg = "#f5e3b5" }, use_mode_colors = false },
            "diff",
            "diagnostics",
          },
          lualine_c = { { "%f", padding = { left = 2 } } },
          lualine_x = { "filetype" },
          lualine_y = { "location" },
          lualine_z = { "progress" },
        },
      })
    end,
  },
}
