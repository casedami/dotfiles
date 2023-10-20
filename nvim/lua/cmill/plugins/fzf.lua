return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    event = { "BufRead", "BufNewFile" },
    version = false, -- telescope did only one release, so use HEAD for now
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        enabled = vim.fn.executable("make") == 1,
      },
    },
    keys = {
      {
        "<leader>ff",
        "<cmd>Telescope find_files<cr>",
        desc = "Toggle Telescope",
        silent = true,
      },
      {
        "<leader>fg",
        "<cmd>Telescope live_grep<cr>",
        desc = "Toggle Telescope live_grep",
        silent = true,
      },
      {
        "<leader>,",
        "<cmd>Telescope buffers<cr>",
        desc = "Toggle Telescope buffers",
        silent = true,
      },
      {
        "<leader>s",
        "<cmd>Telescope registers<cr>",
        desc = "Registers",
        silent = true,
      },
    },
    opts = function()
      return {
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
      }
    end,
  },
}
