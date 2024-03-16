return {
  {
    "cdmill/neomodern.nvim",
    config = function()
      require("neomodern").setup({
        -- style = "roseprime",
        lualine = {
          transparent = true,
        },
      })
      require("neomodern").load()
    end,
  },
}
