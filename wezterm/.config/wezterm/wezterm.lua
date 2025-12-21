-- WezTerm configuration with theme toggle support
-- https://wezfurlong.org/wezterm/

local wezterm = require("wezterm")

-- Theme file location
local theme_file = os.getenv("HOME") .. "/.config/current-theme"

-- Read current theme from file (default: light)
local function get_theme()
    local file = io.open(theme_file, "r")
    if file then
        local theme = file:read("*l")
        file:close()
        return theme or "light"
    end
    return "light"
end

-- Color schemes
local schemes = {
    dark = {
        -- Catppuccin Frappe
        background = "#303446",
        foreground = "#c6d0f5",
        cursor_bg = "#f2d5cf",
        cursor_fg = "#303446",
        selection_bg = "#626880",
        selection_fg = "#c6d0f5",
        ansi = { "#51576d", "#e78284", "#a6d189", "#e5c890", "#8caaee", "#ca9ee6", "#81c8be", "#b5bfe2" },
        brights = { "#626880", "#e78284", "#a6d189", "#e5c890", "#8caaee", "#ca9ee6", "#81c8be", "#a5adce" },
    },
    light = {
        -- Catppuccin Latte
        background = "#eff1f5",
        foreground = "#4c4f69",
        cursor_bg = "#dc8a78",
        cursor_fg = "#eff1f5",
        selection_bg = "#acb0be",
        selection_fg = "#4c4f69",
        ansi = { "#5c5f77", "#d20f39", "#40a02b", "#df8e1d", "#1e66f5", "#8839ef", "#179299", "#acb0be" },
        brights = { "#6c6f85", "#d20f39", "#40a02b", "#df8e1d", "#1e66f5", "#8839ef", "#179299", "#bcc0cc" },
    },
}

-- Get current color scheme
local current_theme = get_theme()
local colors = schemes[current_theme] or schemes.dark

-- Watch theme file for changes
wezterm.add_to_config_reload_watch_list(theme_file)

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
    -- Colors (theme-aware)
    colors = colors,

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
