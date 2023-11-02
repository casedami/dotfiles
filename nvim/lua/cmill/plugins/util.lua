return {
  {
    "folke/persistence.nvim",
    event = "BufRead",
    opts = {
      options = {
        "buffers",
        "curdir",
        "tabpages",
        "winsize",
        "help",
        "globals",
        "skiprtp",
      },
    },
    -- stylua: ignore
    keys = {
      { "<leader>ss", function() require("persistence").load() end, desc = "Restore Session" },
      { "<leader>sl", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
    },
  },
  {
    "tpope/vim-fugitive",
    event = "BufRead",
    keys = {
      { "<leader>gs", "<cmd>Git status<cr>" },
      { "<leader>gl", "<cmd>Git log1<cr>" },
      { "<leader>gL", "<cmd>Git glog<cr>" },
      { "<leader>gg", ":Git " },
    },
  },
  {
    "luukvbaal/statuscol.nvim",
    event = "BufRead",
    config = function()
      local builtin = require("statuscol.builtin")
      require("statuscol").setup({
        relculright = true,
        setopt = true,
        segments = {
          {
            text = { " ", "%s" },
            condition = {
              function(args)
                return ((args.nu or args.rnu) and not args.empty)
              end,
              true,
            },
          },
          {
            text = { builtin.lnumfunc, "  " },
            click = "v:lua.ScLa",
            condition = {
              function(args)
                return ((args.nu or args.rnu) and not args.empty)
              end,
              function(args)
                return ((args.nu or args.rnu) and not args.empty)
              end,
            },
          },
        },
      })
    end,
  },
}
