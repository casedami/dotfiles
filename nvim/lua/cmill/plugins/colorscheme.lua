return {
  {
    "cdmill/saguaro.nvim",
    config = function()
      require("saguaro").setup({
        lualine = {
          transparent = true,
        },
      })
      require("saguaro").load()
    end,
  },
}
