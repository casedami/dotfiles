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
  color_scheme = "darkforest",
  -- macos_window_background_blur = 100,
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

-- config.leader = { key = 'b', mods = 'CTRL', timeout_milliseconds = 1000 }
-- config.keys = {
--     -- splitting
--     { mods = "LEADER", key = "-",          action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
--     { mods = "LEADER", key = "/",          action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
--     { mods = "LEADER", key = 'LeftArrow',  action = wezterm.action.ActivatePaneDirection 'Left' },
--     { mods = "LEADER", key = 'h',          action = wezterm.action.ActivatePaneDirection 'Left' },
--     { mods = "LEADER", key = 'RightArrow', action = wezterm.action.ActivatePaneDirection 'Right' },
--     { mods = "LEADER", key = 'l',          action = wezterm.action.ActivatePaneDirection 'Right' },
--     { mods = "LEADER", key = 'UpArrow',    action = wezterm.action.ActivatePaneDirection 'Up' },
--     { mods = "LEADER", key = 'k',          action = wezterm.action.ActivatePaneDirection 'Up' },
--     { mods = "LEADER", key = 'DownArrow',  action = wezterm.action.ActivatePaneDirection 'Down' },
--     { mods = "LEADER", key = 'j',          action = wezterm.action.ActivatePaneDirection 'Down' },
--     { mods = 'LEADER', key = 'p',          action = wezterm.action.ActivateTabRelative(-1) },
--     { mods = 'LEADER', key = 'n',          action = wezterm.action.ActivateTabRelative(1) },
--     { mods = 'LEADER', key = 'x',          action = wezterm.action.CloseCurrentPane { confirm = false }, },
--     { mods = 'LEADER', key = 'X',          action = wezterm.action.CloseCurrentTab { confirm = false }, },
--     { mods = 'LEADER', key = 'c',          action = wezterm.action.SpawnTab 'CurrentPaneDomain', },
--     {
--         mods = 'LEADER',
--         key = '!',
--         action = wezterm.action_callback(function(_win, pane)
--             local _tab, _ = pane
--                 :move_to_new_tab()
--         end),
--     }
-- }
--
-- for i = 1, 9 do
--     -- ALT + number to activate that tab
--     table.insert(config.keys, {
--         key = tostring(i),
--         mods = 'LEADER',
--         action = wezterm.action.ActivateTab(i - 1),
--     })
-- end
--
return config
