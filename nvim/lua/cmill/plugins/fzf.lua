return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    event = { "BufRead", "BufNewFile" },
    version = false,
    dependencies = {
      { "nvim-telescope/telescope-fzy-native.nvim" },
    },
    -- stylua: ignore
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Toggle Telescope", silent = true, },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Toggle Telescope live_grep", silent = true, },
      { "<leader>fr", "<cmd>Telescope resume<cr>", desc = "Toggle Telescope resume", silent = true, },
      { "<leader>,", "<cmd>Telescope buffers<cr>", desc = "Toggle Telescope buffers", silent = true, },
      { "<leader>s", "<cmd>Telescope registers<cr>", desc = "Registers", silent = true, },
      { "<leader>m", "<cmd>Telescope marks<cr>", desc = "Marks", silent = true, },
      { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Git status", silent = true, },
      { "<leader>gc", "<cmd>Telescope git_bcommits<cr>", desc = "Git commits for current buffer", silent = true, },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          file_ignore_patterns = {
            "%.aux",
            "%.log",
            "%.xdv",
            "%.lof",
            "%.lot",
            "%.fls",
            "%.out",
            "%.toc",
            "%.fmt",
            "%.fot",
            "%.cb",
            "%.cb2",
            "%.nav",
            "%.snm",
            "%.*%.lb",
            "__latex*",
            "%.fdb_latexmk",
            "%.synctex",
            "%.synctex(busy)",
            "%.synctex.gz",
            "%.synctex.gz(busy)",
            "%.pdfsync",
            "%.pygstyle",
            "%.bbl",
            "%.bcf",
            "%.blg",
            "%.run.xml",
            "indent.log",
            "%.pdf",
            "%.bak",
            "%.app",
            "%.lock",
            ".DS_Store",
          },
        },
        pickers = {
          find_files = {
            mappings = {
              n = {
                ["kj"] = "close",
              },
            },
          },
          marks = {
            theme = "ivy",
          },
          registers = {
            theme = "dropdown",
          },
        },
        path_display = { "truncate" },
      })
      require("telescope").load_extension("fzy_native")
    end,
  },
}
