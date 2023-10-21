local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta

return {
  s({ trig = "it", dscr = "italics" }, fmta("*<>*", { i(1) }), {}),
  s({ trig = "bd", dscr = "bolded" }, fmta("**<>**", { i(1) }), {}),
  s({ trig = "hh", dscr = "highlight" }, fmta("==<>==", { i(1) }), {}),
  s(
    { trig = "cc", dscr = "code block" },
    fmta(
      [[
        ```<>
        ```
      ]],
      { i(1) }
    ),
    {}
  ),
}
