return {
  {
    "cdmill/saguaro.nvim",
    config = function()
      require("saguaro").setup({
        transparent = true,
        lualine = {
          transparent = true,
        },
      })
      require("saguaro").load()
    end,
  },
}
