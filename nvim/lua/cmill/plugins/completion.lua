return {
  {
    "saghen/blink.cmp",
    event = "VeryLazy",
    dependencies = {
      { "rafamadriz/friendly-snippets" },
    },
    version = "*",
    config = function()
      require("blink.cmp").setup({
        keymap = {
          preset = "none",
          ["<Tab>"] = {
            function(cmp)
              if cmp.snippet_active() then
                return cmp.accept()
              else
                return require("blink.cmp").accept()
              end
            end,
            "snippet_forward",
            "fallback",
          },
          ["<S-Tab>"] = {
            "snippet_backward",
            "fallback",
          },
          ["<C-n>"] = { "select_next", "fallback" },
          ["<C-p>"] = { "select_prev", "fallback" },
        },
        signature = {
          enabled = true,
          window = {
            border = "rounded",
          },
        },
        sources = {
          default = {
            "lsp",
            "path",
            "snippets",
            "buffer",
            "lazydev",
          },
          providers = {
            lazydev = {
              name = "LazyDev",
              module = "lazydev.integrations.blink",
              fallbacks = { "lsp" },
            },
          },
        },
        appearance = {
          kind_icons = {
            Snippet = "",
            Folder = " ",
          },
        },
        completion = {
          keyword = {
            range = "full",
          },
          list = {
            selection = {
              auto_insert = true,
            },
          },
          accept = {
            auto_brackets = {
              enabled = true,
            },
          },
          menu = {
            min_width = 20,
            border = "rounded",
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
            draw = {
              columns = {
                { "kind_icon", gap = 4 },
                { "label", gap = 4 },
                { "source_name" },
              },
              components = {
                source_name = {
                  text = function(ctx)
                    local map = {
                      ["lsp"] = " ",
                      ["path"] = " ",
                      ["snippets"] = " ",
                    }

                    return map[ctx.item.source_id]
                  end,
                  highlight = "BlinkCmpSource",
                },
              },
            },
          },
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 100,
            update_delay_ms = 10,
            window = {
              max_width = math.min(80, vim.o.columns),
              border = "rounded",
            },
          },
        },
      })
    end,
  },
}
