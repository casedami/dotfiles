local wezterm = require("wezterm")

local config = wezterm.config_builder()

local cfg = {
  audible_bell = "Disabled",
  automatically_reload_config = true,
  color_scheme_dirs = { "~/.config/wezterm/colors/" },
  color_scheme = "iceclimber",
  colors = {
    tab_bar = {
      active_tab = {
        bg_color = "#1d1d1f",
        fg_color = "#55555e",
      },
      inactive_tab = {
        bg_color = "#111111",
        fg_color = "#55555e",
      },
    },
  },
  font = wezterm.font("MonaspiceAr Nerd Font"),
  font_size = 13,
  font_rules = {
    {
      intensity = "Bold",
      italic = false,
      font = wezterm.font({
        family = "MonaspiceXe Nerd Font",
      }),
    },
    {
      intensity = "Bold",
      italic = true,
      font = wezterm.font({
        family = "MonaspiceKr Nerd Font",
        italic = true,
      }),
    },
    {
      intensity = "Normal",
      italic = true,
      font = wezterm.font({
        family = "MonaspiceKr Nerd Font",
        italic = true,
      }),
    },
    {
      intensity = "Half",
      italic = true,
      font = wezterm.font({
        family = "MonaspiceKr Nerd Font",
        italic = true,
      }),
    },
  },
  enable_tab_bar = false,
  visual_bell = {
    fade_in_duration_ms = 0,
    fade_out_duration_ms = 0,
  },
  window_background_opacity = 1.0,
  window_close_confirmation = "NeverPrompt",
  window_frame = {
    active_titlebar_bg = "#171718",
    font = wezterm.font({
      family = "MonaspiceRn Nerd Font",
    }),
  },
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

return config
