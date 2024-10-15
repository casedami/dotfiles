return {
  { "hrsh7th/cmp-omni", ft = "tex" },
  {
    "hrsh7th/nvim-cmp",
    event = "LspAttach",
    dependencies = {
      { "onsails/lspkind.nvim" },
      { "saadparwaiz1/cmp_luasnip" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-buffer" },
    },
    config = function()
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
      local cmp = require("cmp")
      local defaults = require("cmp.config.default")()
      local lspkind = require("lspkind")
      local cmp_window = require("cmp.config.window")
      cmp.setup({
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        -- stylua: ignore
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert, }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert, }),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["W"] = cmp.mapping.abort(),
          ["<tab>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "luasnip" },
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
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
            follow_cursor = true,
            selection_order = "top_down",
          },
        },
        sorting = defaults.sorting,
      })

      cmp.setup.filetype("tex", {
        sources = {
          { name = "omni", trigger_characters = { "{", "\\" } },
          { name = "buffer" },
        },
      })
    end,
  },
}
