local wezterm = require("wezterm")

local config = wezterm.config_builder()

local cfg = {
  audible_bell = "Disabled",
  automatically_reload_config = true,
  color_scheme_dirs = { "~/.config/wezterm/colors/" },
  color_scheme = "iceclimber",
  font = wezterm.font("JetBrainsMono Nerd Font"),
  font_rules = {
    {
      intensity = "Bold",
      italic = false,
      font = wezterm.font({
        family = "JetBrainsMono Nerd Font",
        weight = "ExtraBold",
        italic = false,
      }),
    },
    {
      intensity = "Bold",
      italic = true,
      font = wezterm.font({
        family = "JetBrainsMono Nerd Font",
        weight = "ExtraBold",
        italic = true,
      }),
    },
  },
  font_size = 14,
  enable_tab_bar = false,
  visual_bell = {
    fade_in_duration_ms = 0,
    fade_out_duration_ms = 0,
  },
  window_background_opacity = 1.0,
  window_close_confirmation = "NeverPrompt",
  window_padding = {
    left = 2,
    right = 2,
    top = 10,
    bottom = 0,
  },
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

config.keys = {
  {
    key = "B",
    mods = "CTRL",
    action = wezterm.action.EmitEvent("toggle-opacity"),
  },
}

return config
