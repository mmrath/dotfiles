-- WezTerm configuration
-- https://wezfurlong.org/wezterm/

local wezterm = require("wezterm")

-- Tab title formatting
local function format_tab_title(tab, max_width)
    local title = " " .. (tab.tab_index + 1) .. ": " .. tab.active_pane.title .. " "
    if #title <= max_width then
        return title
    end
    return wezterm.truncate_right(title, max_width - 5) .. "... "
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
    local title = format_tab_title(tab, max_width)
    if tab.is_active then
        return {
            { Attribute = { Intensity = "Bold" } },
            { Text = title },
        }
    end
    return { { Text = title } }
end)

return {
    -- Soft light colors (easier on eyes)
    colors = {
        background = "#f5f5f0",
        foreground = "#24292f",
        cursor_bg = "#24292f",
        cursor_fg = "#f5f5f0",
        selection_bg = "#c8e1ff",
        selection_fg = "#24292f",
        -- Colorblind-friendly: red→orange, green→blue
        ansi = { "#24292f", "#dc6d09", "#0969da", "#b45309", "#0969da", "#8250df", "#1b7c83", "#6e7781" },
        brights = { "#57606a", "#c45d10", "#0550ae", "#9a5000", "#0550ae", "#6639ba", "#136061", "#8c959f" },
    },

    -- Font
    font = wezterm.font_with_fallback({
        "Maple Mono NF",
        "JetBrainsMono Nerd Font",
    }),
    font_size = 15.0,
    line_height = 1.1,

    -- Cursor
    default_cursor_style = "BlinkingBar",
    force_reverse_video_cursor = true,

    -- Window
    initial_rows = 30,
    initial_cols = 120,
    window_padding = { left = 4, right = 4, top = 4, bottom = 4 },
    window_background_opacity = 1.0,
    window_close_confirmation = "NeverPrompt",
    automatically_reload_config = true,

    -- Scroll bar
    enable_scroll_bar = true,

    -- Tab bar
    enable_tab_bar = true,
    hide_tab_bar_if_only_one_tab = false,
    use_fancy_tab_bar = false,
    tab_max_width = 25,
    show_tab_index_in_tab_bar = false,
    switch_to_last_active_tab_when_closing_tab = true,

    -- Panes
    inactive_pane_hsb = { saturation = 1.0, brightness = 1.0 },

    -- Mouse bindings
    mouse_bindings = {
        -- Ctrl-click opens links
        {
            event = { Up = { streak = 1, button = "Left" } },
            mods = "CTRL",
            action = wezterm.action.OpenLinkAtMouseCursor,
        },
    },
}
