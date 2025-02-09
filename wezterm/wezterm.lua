local wezterm = require("wezterm")

local config = wezterm.config_builder()

local cfg = {
  automatically_reload_config = true,
  -- BELL
  audible_bell = "Disabled",
  visual_bell = {
    fade_in_duration_ms = 0,
    fade_out_duration_ms = 0,
  },
  -- UI
  color_scheme_dirs = { "~/.config/wezterm/colors/" },
  color_scheme = "iceclimber",
  -- macos_window_background_blur = 20,
  window_background_opacity = 1.0,
  window_decorations = "RESIZE",
  window_close_confirmation = "NeverPrompt",
  window_padding = {
    left = 2,
    right = 2,
    top = 10,
    bottom = 0,
  },
  -- FONT
  font_size = 14,
  line_height = 1.2,
  font = wezterm.font({
    family = "CommitMono Nerd Font",
    harfbuzz_features = { "ss03=1", "ss04=1", "ss05=1", "cv02=1", "cv08=1" },
  }),
  -- TAB BAR
  enable_tab_bar = false,
}

for k, v in pairs(cfg) do
  config[k] = v
end

require("wezterm").on("format-window-title", function()
  return ""
end)

wezterm.on("toggle-opacity", function(window, _)
  local overrides = window:get_config_overrides() or {}
  if overrides.window_background_opacity == 1.0 then
    overrides.window_background_opacity = 0.9
  else
    overrides.window_background_opacity = 1.0
  end
  window:set_config_overrides(overrides)
end)

wezterm.on("toggle-colorscheme", function(window, _)
  local overrides = window:get_config_overrides() or {}
  if overrides.color_scheme == "iceclimber" then
    overrides.color_scheme = "daylight"
  else
    overrides.color_scheme = "iceclimber"
  end
  window:set_config_overrides(overrides)
end)

config.keys = {
  {
    key = "B",
    mods = "CTRL",
    action = wezterm.action.EmitEvent("toggle-opacity"),
  },
  {
    key = "C",
    mods = "CTRL",
    action = wezterm.action.EmitEvent("toggle-colorscheme"),
  },
}

return config
