return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
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
    cmd = "G",
  },
}
