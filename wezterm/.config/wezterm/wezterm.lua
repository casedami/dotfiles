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
    color_scheme = "iceclimber",
    default_prog = { "/Users/cdm/.cargo/bin/nu" },
    disable_default_key_bindings = true,
    window_background_opacity = 1.0,
    --window_decorations = "NONE",
    window_close_confirmation = "NeverPrompt",
    window_padding = {
        left = 10,
        right = 0,
        top = 10,
        bottom = 0,
    },
    -- FONT
    font_size = 11,
    line_height = 1.0,
    font = wezterm.font({
        family = "Lilex Nerd Font",
        harfbuzz_features = {
            "zero=1",
            "ss02=1",
            "cv02=1",
            "cv09=1",
        },
    }),
    -- TAB BAR
    enable_tab_bar = false,
    keys = {
        {
            key = "P",
            mods = "CTRL|SHIFT",
            action = wezterm.action.DisableDefaultAssignment,
        },
    },
}

for k, v in pairs(cfg) do
    config[k] = v
end

-- require("wezterm").on("format-window-title", function()
--     return ""
-- end)

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
