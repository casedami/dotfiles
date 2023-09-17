return {
  "L3MON4D3/LuaSnip",
  config = require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/" }),
  opts = {
    history = true,
    delete_check_events = "TextChanged",
    update_events = { "TextChanged", "TextChangedI" },
  },
}
