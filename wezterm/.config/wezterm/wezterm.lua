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
    color_scheme_dirs = { "~/.config/wezterm/colors" },
    color_scheme = "gyokuro",
    default_prog = { "nu" },
    window_background_opacity = 1.0,
    window_decorations = "NONE",
    window_close_confirmation = "NeverPrompt",
    window_padding = {
        left = 6,
        right = 0,
        top = 0,
        bottom = 0,
    },
    -- FONT
    font_size = 12,
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

return config
