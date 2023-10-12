local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node

return {
  s({ trig = "sb", dscr = "shebang" }, { t("#!/usr/bin/env python3") }),
}
