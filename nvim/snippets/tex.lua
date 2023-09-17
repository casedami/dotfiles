local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta
local line_begin = require("luasnip.extras.expand_conditions").line_begin
local rep = require("luasnip.extras").rep

return {
  -- GENERIC ENVIRONMENT
  s(
    "nenv",
    fmta(
      [[
        \begin{<>}
          <> 
        \end{<>}
      ]],
      {
        i(1, "env"),
        i(0, "body"),
        rep(1),
      }
    ),
    { condition = line_begin }
  ),
  s(
    "tikz",
    fmta(
      [[
          \begin{tikzpicture}[baseline]
            \node[state, initial] (q0) {$q_0$};
            \node[state, right of=q0] (q1) {$q_1$};

            \draw
            (q0) edge [above] node {<>};

          \end{tikzpicture}
        ]],
      {
        i(0, "transition"),
      }
    ),
    { condition = line_begin }
  ),
}
