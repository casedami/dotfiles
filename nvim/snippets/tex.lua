local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

return {
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
        i(0),
        rep(1),
      }
    ),
    {}
  ),
  s(
    "tikz",
    fmta(
      [[
        \begin{tikzpicture}[baseline]
          <>
        \end{tikzpicture}
      ]],
      {
        i(0),
      }
    ),
    {}
  ),
  s(
    "fsm",
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
    {}
  ),
  s({ trig = "mm", dscr = "inline math" }, fmta("\\( <> \\)", { i(1) }), {}),
  s({ trig = "ff", dscr = "fraction" }, fmta("\\frac{<>}{<>}", { i(1), i(2) }), {}),
  s({ trig = "ss", dscr = "quick math" }, fmta("$<>$", { i(1) }), {}),
  s({ trig = "bf", dscr = "boldface" }, fmta("\\textbf{<>}", { i(1) }), {}),
  s({ trig = "if", dscr = "italics" }, fmta("\\textit{<>}", { i(1) }), {}),
  s({ trig = "tt", dscr = "mono" }, fmta("\\texttt{<>}", { i(1) }), {}),
  s(
    { trig = "setdef", dscr = "set definition" },
    fmta("\\( \\{<>\\} \\)", { i(1) }),
    {}
  ),
}
