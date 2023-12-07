return {
  {
    "sainnhe/everforest",
    priority = 1000,
    -- stylua: ignore
    config = function()
      vim.g.everforest_background = "hard"
      vim.g.everforest_performance = 1
      vim.g.everforest_ui_contrast = "low"
      vim.g.everforest_float_style = "dim"
      vim.g.everforest_cursor = "orange"
      vim.cmd("colorscheme everforest")
      local colors = require("cmill.core.colors").highlights
      vim.cmd(string.format("hi Normal guibg=%s", colors.bg))
      vim.cmd(string.format("hi NormalNC guibg=%s", colors.bg))
      vim.cmd(string.format("hi CursorLineNr guifg=%s", colors.orange))
      vim.cmd(string.format("hi MatchParen gui=bold guifg=%s guibg=%s", colors.orange, colors.bg))
      vim.cmd(string.format("hi NormalFloat guibg=%s", colors.float))
      vim.cmd(string.format("hi TelescopeBorder guifg=%s", colors.border))
      vim.cmd(string.format("hi ColorColumn guibg=%s", colors.line))
      vim.cmd(string.format("hi CursorLine guibg=%s", colors.line))
      vim.cmd(string.format("hi Folded guibg=%s", colors.line))
    end,
  },
}
