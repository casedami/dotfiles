return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      {
        "<leader>e",
        "<cmd>Neotree focus toggle<cr>",
        desc = "Toggle NeoTree ",
        silent = true,
      },
    },
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    opts = {
      sources = { "filesystem", "buffers", "git_status", "document_symbols" },
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
      },
      window = {
        mappings = {
          -- ["<space>"] = "none",
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true,
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
      },
    },
    config = function()
      require("neo-tree").setup({})
      -- BUG: need to do this differently
      -- vim.api.nvim_command(
      --   [[autocmd ColorScheme * highlight NeoTreeNormal guibg=#272E33]]
      -- [[autocmd ColorScheme * highlight NeoTreeEndOfBuffer guibg=#272E33]]
      -- )
    end,
  },
}
