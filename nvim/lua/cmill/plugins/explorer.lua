return {
  {
    "stevearc/oil.nvim",
    event = "VimEnter",
    keys = {
      { "<leader>fe", "<cmd>Oil<cr>" },
    },
    cmd = "Oil",
    config = function()
      require("oil").setup({
        default_file_explorer = true,
        view_options = {
          show_hidden = true,
        },
        columns = {},
        keymaps = {
          ["g?"] = "actions.show_help",
          ["<CR>"] = "actions.select",
          ["<C-s>"] = "actions.select_vsplit",
          ["<C-h>"] = "actions.select_split",
          ["<C-t>"] = "actions.select_tab",
          ["<C-p>"] = "actions.preview",
          ["<C-l>"] = "actions.refresh",
          ["q"] = "actions.close",
          ["-"] = "actions.parent",
          ["_"] = "actions.open_cwd",
          ["`"] = "actions.cd",
          ["~"] = "actions.tcd",
          ["gs"] = "actions.change_sort",
          ["gx"] = "actions.open_external",
          ["g."] = "actions.toggle_hidden",
          ["g\\"] = "actions.toggle_trash",
        },
      })
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false,
    dependencies = {
      { "nvim-telescope/telescope-fzy-native.nvim" },
    },
    -- stylua: ignore
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Toggle Telescope", silent = true, },
      { "<leader>fb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Toggle Telescope current buffer", silent = true, },
      { "<leader>fl", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Toggle Telescope lsp symbols", silent = true, },
      { "<leader>fr", "<cmd>Telescope oldfiles cwd_only=true<cr>", desc = "Toggle Telescope recent files", silent = true, },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Toggle Telescope live_grep", silent = true, },
      { "<leader>fR", "<cmd>Telescope resume<cr>", desc = "Toggle Telescope resume", silent = true, },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Toggle Telescope help", silent = true, },
      { "<leader>,", "<cmd>Telescope buffers<cr>", desc = "Toggle Telescope buffers", silent = true, },
      { "<leader>fs", "<cmd>Telescope registers<cr>", desc = "Registers", silent = true, },
      { "<leader>fm", "<cmd>Telescope marks<cr>", desc = "Marks", silent = true, },
      { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Git status", silent = true, },
      { "<leader>gc", "<cmd>Telescope git_bcommits<cr>", desc = "Git commits for current buffer", silent = true, },
      { "<leader>fc", require("cmill.core.util").config, desc = "Open config files" },
    },
    config = function()
      -- stylua: ignore
      require("telescope.pickers.layout_strategies").horizontal_merged = function( picker, max_columns, max_lines, layout_config)
        local layout = require("telescope.pickers.layout_strategies").horizontal( picker, max_columns, max_lines, layout_config)
        layout.prompt.title = ""
        layout.results.title = ""
        if layout.preview then layout.preview.title = "" end
        return layout
      end
      require("telescope").setup({
        defaults = {
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
            "__pycache__",
            ".DS_Store",
          },
          prompt_prefix = " ",
          selection_caret = "󰘍 ",
          layout_strategy = "horizontal_merged",
          sorting_strategy = "ascending",
          scroll_strategy = "cycle",
          path_display = { "truncate" },
          color_devicons = true,
          winblend = 0,
          layout_config = {
            width = 0.99,
            height = 0.65,
            prompt_position = "top",
            horizontal = {
              anchor = "S",
              preview_width = function(_, cols, _)
                return math.floor(cols * 0.6)
              end,
            },
          },
          mappings = {
            n = {
              ["p"] = require("telescope.actions").close,
            },
            i = {
              ["PP"] = require("telescope.actions").close,
            },
          },
        },
        pickers = {
          registers = {
            theme = "dropdown",
          },
        },
      })
      require("telescope").load_extension("fzy_native")
    end,
  },
}
