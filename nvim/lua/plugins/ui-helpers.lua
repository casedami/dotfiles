return {
  {
    "folke/which-key.nvim",
    -- enabled = false,
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 800
    end,
    opts = {
      triggers_blacklist = {
        n = { "v" },
      },
    },
  },
  {
    "rcarriga/nvim-notify",
    opts = {
      level = 4,
      render = "compact",
      stages = "static",
    },
  },
}
