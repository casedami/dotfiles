import json, sys

vil_path, info_path, layout_name, out_path = sys.argv[1:5]

vil = json.load(open(vil_path))
info = json.load(open(info_path))
key_order = info["layouts"][layout_name]["layout"]

layers = []
for layer_matrix in vil["layout"]:
    flat = []
    for key in key_order:
        row, col = key["matrix"]
        code = layer_matrix[row][col]
        if code == -1 or code == "KC_NO":
            flat.append("KC_NO")
        else:
            flat.append(code)
    layers.append(flat)

out = {
    "keyboard": "crkbd/rev4_1/standard",
    "keymap": "vial_live",
    "layout": layout_name,
    "layers": layers,
}
json.dump(out, open(out_path, "w"))
print(f"wrote {len(layers)} layers to {out_path}")
