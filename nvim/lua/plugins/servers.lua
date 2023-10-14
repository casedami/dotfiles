return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(
          opts.ensure_installed,
          { "c", "cpp", "python", "markdown_inline", "swift" }
        )
      end
      opts.highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "markdown" },
      }
    end,
  },
  { "lervag/vimtex" },
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        virtual_text = false,
      },
      servers = {
        pyright = {},
        clangd = {},
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "pyright",
        "black",
        "clangd",
        "clang-format",
        "latexindent",
        "prettier",
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        sh = { "shfmt" },
        python = { "black" },
        markdown = { "prettier" },
        c = { "clang-format" },
        tex = { "latexindent" },
      },
      formatters = {
        latexindent = {
          extra_args = { "-m", "-c=./generated/" },
        },
      },
    },
  },
  {
    "L3MON4D3/LuaSnip",
    opts = {
      history = true,
      delete_check_events = "TextChanged",
      update_events = { "TextChanged", "TextChangedI" },
    },
  },
}
