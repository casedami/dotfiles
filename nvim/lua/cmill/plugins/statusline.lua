return {
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = require("cmill.core.util").statusline(),
          section_separators = { left = "", right = "" },
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
            {
              "filename",
              path = 3,
              symbols = {
                modified = "*",
                newfile = "[NEW]",
              },
            },
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
          lualine_c = {},
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
            {
              "filetype",
              colored = false,
              icon_only = true,
            },
            "progress",
            { "location", padding = { right = 2 } },
          },
          lualine_y = {},
          lualine_z = {},
        },
      })
    end,
  },
}
