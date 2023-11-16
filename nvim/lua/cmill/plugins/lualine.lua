local catppuccin = {
  bg = "#11111b",
  fg = "#51576d",
  fg_hi = "#cdd6f4",
  mode_nor = "#a6adc8",
  mode_com = "#ef9f76",
  mode_ins = "#e5c890",
  mode_vis = "#ca9ee6",
  mode_rep = "#81c8be",
}
-- local gruvbox = {
--   bg = "#282828",
--   fg = "#7c6f64",
--   fg_hi = "#ddc7a1",
--   mode_nor = "#a89984",
--   mode_com = "#e78a4e",
--   mode_ins = "#d8a657",
--   mode_vis = "#d3869b",
--   mode_rep = "#89b482",
-- }

local colors = catppuccin

return {
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = {
            normal = {
              a = { bg = colors.bg, fg = colors.mode_nor },
              b = { bg = colors.bg, fg = colors.fg },
              c = { bg = colors.bg, fg = colors.fg },
            },
            insert = {
              a = { bg = colors.bg, fg = colors.mode_ins },
              b = { bg = colors.bg, fg = colors.fg },
              c = { bg = colors.bg, fg = colors.fg },
            },
            visual = {
              a = { bg = colors.bg, fg = colors.mode_vis },
              b = { bg = colors.bg, fg = colors.fg },
              c = { bg = colors.bg, fg = colors.fg },
            },
            replace = {
              a = { bg = colors.bg, fg = colors.mode_rep },
              b = { bg = colors.bg, fg = colors.fg },
              c = { bg = colors.bg, fg = colors.fg },
            },
            command = {
              a = { bg = colors.bg, fg = colors.mode_com },
              b = { bg = colors.bg, fg = colors.fg_hi },
              c = { bg = colors.bg, fg = colors.fg_hi },
            },
          },
          section_separators = { left = "", right = "" },
          component_separators = { left = "", right = "" },
          disabled_filetypes = { "dashboard", "toggleterm" },
          ignore_focus = { "neo-tree" },
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
            { "mode", padding = { left = 2 } },
          },
          lualine_b = {
            { "filename", path = 3 },
          },
          lualine_c = {
            { "branch", icon = "", padding = { left = -1 } },
            {
              "diff",
              colored = false,
            },
            "diagnostics",
          },
          lualine_x = {},
          lualine_y = {
            {
              "filetype",
              colored = false,
              icon_only = true,
            },
            "progress",
            { "location", padding = { right = 2 } },
          },
          lualine_z = {},
        },
        tabline = {
          lualine_a = {
            {
              "tabs",
              show_modified_status = false,
              cond = function()
                if vim.api.nvim_eval("len(gettabinfo())") == "1" then
                  vim.cmd("set showtabline=0")
                  return false
                else
                  vim.cmd("set showtabline=1")
                  return true
                end
              end,
            },
          },
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {},
        },
      })
    end,
  },
}
