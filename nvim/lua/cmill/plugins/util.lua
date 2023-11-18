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
        "folds",
      },
    },
  },
  {
    "tpope/vim-fugitive",
    event = "BufRead",
    keys = {
      { "<localleader>gs", "<cmd>Git status<cr>" },
      { "<localleader>gl", "<cmd>Git log1<cr>" },
      { "<localleader>gL", "<cmd>Git glog<cr>" },
    },
    cmd = "G",
  },
}
