return {
  {
    "hrsh7th/nvim-cmp",
    event = "VeryLazy",
    dependencies = {
      { "onsails/lspkind.nvim" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-cmdline" },
    },
    opts = function(_, opts)
      opts.snippet = {
        expand = function(item)
          return require("cmill.core.util").expand_snip(item.body)
        end,
      }
      opts.sources = opts.sources or {}
      table.insert(opts.sources, {
        name = "lazydev",
        group_index = 0,
      })
    end,
    config = function()
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
      local cmp = require("cmp")
      local defaults = require("cmp.config.default")()
      local lspkind = require("lspkind")
      local cmp_window = require("cmp.config.window")
      local maps = {
        ["<C-n>"] = {
          c = cmp.mapping.select_next_item({
            behavior = cmp.SelectBehavior.Insert,
          }),
          i = cmp.mapping.select_next_item({
            behavior = cmp.SelectBehavior.Insert,
          }),
        },
        ["<C-p>"] = {
          c = cmp.mapping.select_prev_item({
            behavior = cmp.SelectBehavior.Insert,
          }),
          i = cmp.mapping.select_prev_item({
            behavior = cmp.SelectBehavior.Insert,
          }),
        },
        ["<C-Space>"] = {
          c = cmp.mapping.complete(),
          i = cmp.mapping.complete(),
        },
        ["<C-w>"] = {
          c = cmp.mapping.abort(),
          i = cmp.mapping.abort(),
        },
        ["<Tab>"] = {
          c = cmp.mapping.confirm({ select = true }),
          i = cmp.mapping.confirm({ select = true }),
        },
      }
      cmp.setup.cmdline("/", {
        mapping = maps,
        sources = {
          { name = "buffer" },
        },
      })
      cmp.setup.cmdline(":", {
        mapping = maps,
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          {
            name = "cmdline",
            option = {
              ignore_cmds = { "Man", "!" },
            },
          },
        }),
      })
      cmp.setup({
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        -- stylua: ignore
        mapping = cmp.mapping.preset.insert(maps),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "buffer", max_item_count = 3 },
        }),
        formatting = {
          expandable_indicator = false,
          fields = { "kind", "abbr", "menu" },
          format = lspkind.cmp_format({
            mode = "symbol",
            maxwidth = 12,
            ellipsis_char = "...",
            show_labelDetails = true,
            before = function(_, item)
              return item
            end,
          }),
        },
        experimental = {
          native_menu = false,
          ghost_text = {
            hl_group = "CmpGhostText",
          },
        },
        window = {
          completion = {
            border = "rounded",
            winhighlight = "Normal:Pmenu,CursorLine:PmenuSel,FloatBorder:FloatBorder,Search:None",
            col_offset = -3,
            side_padding = 1,
            scrollbar = false,
            scrolloff = 8,
          },
          documentation = cmp_window.bordered(),
        },
        view = {
          docs = { auto_open = true },
          entries = {
            auto_open = "false",
            follow_cursor = true,
            name = "custom",
            selection_order = "top_down",
          },
        },
        sorting = defaults.sorting,
      })
    end,
    keys = {
      {
        "<Tab>",
        function()
          return vim.snippet.active({ direction = 1 })
              and "<cmd>lua vim.snippet.jump(1)<cr>"
            or "<Tab>"
        end,
        expr = true,
        silent = true,
        mode = { "i", "s" },
      },
      {
        "<S-Tab>",
        function()
          return vim.snippet.active({ direction = -1 })
              and "<cmd>lua vim.snippet.jump(-1)<cr>"
            or "<S-Tab>"
        end,
        expr = true,
        silent = true,
        mode = { "i", "s" },
      },
    },
  },
}
