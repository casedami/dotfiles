return {
  {
    "j-hui/fidget.nvim",
    event = "BufReadPost",
    config = function()
      vim.notify = require("fidget").notify
      require("fidget").setup({
        logger = {
          level = vim.log.levels.DEBUG,
        },
      })
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      local components = require("cmill.core.util").statusline_components()
      local setup = {
        options = {
          icons_enabled = true,
          theme = "neomodern",
          section_separators = { left = "", right = "" },
          -- section_separators = { left = "", right = "" },
          component_separators = { left = "", right = "" },
          disabled_filetypes = {},
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
            components.git_branch,
            components.git_diff,
          },
          lualine_c = {
            components.nvim_icon,
            components.errs,
            components.fname,
          },
          lualine_x = {
            components.ftype,
          },
          lualine_y = {
            components.loc,
            components.prog,
          },
          lualine_z = {
            components.tabs,
          },
        },
      }
      return setup
    end,
  },
}
