return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "c", "cpp", "python" })
      end
    end,
  },
  { "lervag/vimtex" },
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        virtual_text = false,
        float = { border = "rounded" },
      },
      servers = {
        pyright = {},
        black = {},
        latexindent = {},
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
      })
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = vim.list_extend(opts.sources, {
        nls.builtins.formatting.black,
        nls.builtins.formatting.clangformat,
        nls.builtins.formatting.latexindent.with({
          args = { "-m", "-c=./generated/" },
        }),
      })
    end,
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
