import json
import sys
import yaml

vil_yaml_path, info_json_path, layout_name, out_path, vil_json_path = sys.argv[1:6]

data = yaml.safe_load(open(vil_yaml_path))
layers = data["layers"]

info = json.load(open(info_json_path))
key_order = info["layouts"][layout_name]["layout"]

vil = json.load(open(vil_json_path))
TD_MAP = {}
for i, td in enumerate(vil["tap_dance"]):
    tap_kc = td[0]
    if tap_kc and tap_kc != "KC_NO":
        TD_MAP[f"TD({i})"] = tap_kc.removeprefix("KC_").replace("_", " ")

BASE = "Base"
OVERLAYS = [
    ("Num", "#2563eb", "tl"),  # blue, top-left
    ("Sym", "#16a34a", "tr"),  # green, top-right
    ("Nav", "#9333ea", "bl"),  # purple, bottom-left
]
SEPARATE_LAYERS = [("Media", "#dc2626")]  # drawn as their own standalone board

ABBREV = {
    "BSPACE": "⌫", "ENTER": "⏎", "TAB": "⇥", "ESCAPE": "Esc", "SPACE": "␣",
    "LEFT": "←", "RIGHT": "→", "UP": "↑", "DOWN": "↓",
    "HOME": "Home", "END": "End",
    "MS L": "M←", "MS R": "M→", "MS U": "M↑", "MS D": "M↓",
    "VOLU": "Vol+", "VOLD": "Vol-", "MUTE": "Mute",
    "MPLY": "Play", "MPRV": "Prev", "MNXT": "Next",
    "BRIU": "Bri+", "BRID": "Bri-",
    "LBRACKET": "[", "RBRACKET": "]", "BSLASH": "\\", "SCOLON": ";",
    "PSCREEN": "PrSc", "COPY": "Copy", "PSTE": "Paste",
}

MOD_ABBREV = {
    "LALT": "⌥", "LGUI": "⌘", "LCTL": "⌃", "LCTRL": "⌃", "LSFT": "⇧", "LSHIFT": "⇧",
    "RALT": "⌥", "RGUI": "⌘", "RCTL": "⌃", "RCTRL": "⌃", "RSFT": "⇧", "RSHIFT": "⇧",
}


def label_of(cell):
    """Return (text, hold_text_or_None) for a layer cell, or None if blank/trans/held."""
    if cell is None or cell == "":
        return None
    if isinstance(cell, str) and cell in TD_MAP:
        cell = TD_MAP[cell]
    if isinstance(cell, dict):
        if cell.get("type") in ("trans", "held"):
            return None
        t = cell.get("t", "")
        h = cell.get("h")
        text = ABBREV.get(t, t)
        hold = MOD_ABBREV.get(h, h) if h else None
        return (text, hold)
    text = ABBREV.get(cell, cell)
    return (text, None)


LAYER_COLOR = {name: color for name, color, _ in OVERLAYS}
LAYER_COLOR.update({name: color for name, color in SEPARATE_LAYERS})

UNIT = 70
GAP = 6
MARGIN = 30
TITLE_H = 26

xs = [k["x"] for k in key_order]
ys = [k["y"] for k in key_order]
ws = [k.get("w", 1) for k in key_order]
hs = [k.get("h", 1) for k in key_order]
max_x = max(x + w for x, w in zip(xs, ws))
max_y = max(y + h for y, h in zip(ys, hs))

board_w = max_x * UNIT + 2 * MARGIN
board_h = max_y * UNIT + 2 * MARGIN


def draw_board(svg, y_offset, title=None, title_color="#24292e", overlays=None, base_layer=BASE, highlight_color=None):
    if title:
        svg.append(
            f'<text x="{MARGIN}" y="{y_offset + 16}" font-size="13" font-weight="700" fill="{title_color}">{title}</text>'
        )
        y_offset += TITLE_H

    for i, key in enumerate(key_order):
        x = round(key["x"] * UNIT + MARGIN, 1)
        y = round(key["y"] * UNIT + MARGIN + y_offset, 1)
        w = round(key.get("w", 1) * UNIT - GAP, 1)
        h = round(key.get("h", 1) * UNIT - GAP, 1)

        base_cell = layers[base_layer][i]
        base = label_of(base_cell)
        is_held_key = highlight_color and isinstance(base_cell, dict) and base_cell.get("type") == "held"

        if is_held_key:
            svg.append(f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="8" fill="{highlight_color}" fill-opacity="0.15" stroke="{highlight_color}" stroke-width="2.5"/>')
        else:
            svg.append(f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="8" fill="#f6f8fa" stroke="#d0d7de" stroke-width="1.5"/>')

        if base is not None:
            text, hold = base
            if text:
                cy = y + h / 2 + (-6 if hold else 0)
                fill = LAYER_COLOR.get(text, "#24292e")
                weight = "700" if text in LAYER_COLOR else "400"
                svg.append(
                    f'<text x="{x + w/2}" y="{cy + 6}" font-size="17" text-anchor="middle" fill="{fill}" font-weight="{weight}">{text}</text>'
                )
            if hold:
                svg.append(
                    f'<text x="{x + w/2}" y="{y + h/2 + 20}" font-size="11" text-anchor="middle" fill="#8b949e">{hold}</text>'
                )

        no_overlay_keys = {"ESCAPE", "ENTER"}
        skip_overlays = isinstance(base_cell, str) and base_cell in no_overlay_keys
        for name, color, corner in ([] if skip_overlays else (overlays or [])):
            cell = layers[name][i]
            if isinstance(cell, str) and cell in MOD_ABBREV and name not in ("Num", "Sym"):
                continue  # plain modifier hold, redundant with base layer's home-row mod
            res = label_of(cell)
            if res is None:
                continue
            otext, ohold = res
            if isinstance(cell, str) and cell in MOD_ABBREV:
                otext = MOD_ABBREV[cell]
            label = otext if not ohold else f"{otext}/{ohold}"
            if corner == "tl":
                cx, cy, anchor = x + 7, y + 14, "start"
            elif corner == "tr":
                cx, cy, anchor = x + w - 7, y + 14, "end"
            elif corner == "bl":
                cx, cy, anchor = x + 7, y + h - 6, "start"
            else:
                cx, cy, anchor = x + w - 7, y + h - 6, "end"
            svg.append(
                f'<text x="{cx}" y="{cy}" font-size="11" text-anchor="{anchor}" fill="{color}" font-weight="600">{label}</text>'
            )

    return y_offset + board_h


BOARD_GAP = 20
total_height = board_h + BOARD_GAP + len(SEPARATE_LAYERS) * board_h

svg = []
svg.append(
    f'<svg width="{board_w}" height="{total_height}" viewBox="0 0 {board_w} {total_height}" '
    f'xmlns="http://www.w3.org/2000/svg" font-family="SFMono-Regular,Consolas,Menlo,monospace">'
)
svg.append(f'<rect x="0" y="0" width="{board_w}" height="{total_height}" fill="#ffffff"/>')

y = 0
y = draw_board(svg, y, overlays=OVERLAYS)
y += BOARD_GAP

for name, color in SEPARATE_LAYERS:
    y = draw_board(svg, y, overlays=[], base_layer=name, highlight_color=color)

svg.append("</svg>")

open(out_path, "w").write("\n".join(svg))
print(f"wrote {out_path}: {board_w}x{total_height}")
