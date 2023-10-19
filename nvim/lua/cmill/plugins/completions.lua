return {
  {
    "hrsh7th/nvim-cmp",
    event = "LspAttach",
    dependencies = {
      { "hrsh7th/cmp-path", event = "InsertEnter" },
      {
        "L3MON4D3/LuaSnip",
        event = "InsertEnter",
        config = function()
          -- load custom snippets
          require("luasnip.loaders.from_lua").lazy_load({
            paths = "~/.config/nvim/snippets/",
          })
        end,
      },
      -- TODO: remove from cade
      { "saadparwaiz1/cmp_luasnip", event = "InsertEnter" },
      { "hrsh7th/cmp-nvim-lsp", event = "InsertEnter" },
    },
    opts = function()
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
      local cmp = require("cmp")
      local defaults = require("cmp.config.default")()
      return {
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item({
            behavior = cmp.SelectBehavior.Insert,
          }),
          ["<C-p>"] = cmp.mapping.select_prev_item({
            behavior = cmp.SelectBehavior.Insert,
          }),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["W"] = cmp.mapping.abort(),
          ["<tab>"] = cmp.mapping.confirm({ select = true }),
          ["<S-CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
        }),
        sources = cmp.config.sources({
          { name = "luasnip", priority = 40 },
          { name = "nvim_lsp", priority = 30 },
          { name = "path", priority = 10 },
        }),
        formatting = {},
        experimental = {
          ghost_text = {
            hl_group = "CmpGhostText",
          },
        },
        sorting = defaults.sorting,
      }
    end,
  },
}
