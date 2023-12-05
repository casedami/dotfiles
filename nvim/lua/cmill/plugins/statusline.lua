local colors = {
  bg = "#101314",
  fg = "#4F5B58",
  fg_hi = "#272Е33",
  mode_nor = "#9DA9A0",
  mode_com = "#E69875",
  mode_ins = "#DBBC7F",
  mode_vis = "#D699B6",
  mode_rep = "#7FBBB3",
}

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
            {
              "mode",
              icon = { "", color = { fg = "#A7C080" } },
              padding = { left = 1 },
            },
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
            {
              "diagnostics",
              symbols = {
                error = " ",
                warn = "󰹆 ",
                hint = "󰌵 ",
                info = "󰙎 ",
              },
            },
          },
          lualine_x = {
            {
              "tabs",
              show_modified_status = false,
              mode = 0,
              tabs_color = {
                active = "lualine_a_insert",
                inactive = "lualine_b_normal",
              },
              cond = function()
                return vim.api.nvim_eval("len(gettabinfo())") > 1
              end,
            },
          },
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
      })
    end,
  },
}
