local wezterm = require("wezterm")



return {
   color_scheme = 'Dracula',
   -- font
   font = wezterm.font_with_fallback({
      "JetBrainsMono Nerd Font",
      "Iosevka Nerd Font",
      "nonicons",
   }),
   font_size = 13.0,
   line_height = 1.1,
   default_cursor_style = 'BlinkingBar',

   -- scroll bar
   enable_scroll_bar = true,
   initial_rows = 30,
   initial_cols = 120,

   -- status
   status_update_interval = 1000,

   -- tabs/panes
   hide_tab_bar_if_only_one_tab = false,
   enable_tab_bar = true,
   use_fancy_tab_bar = false,
   tab_max_width = 25,
   show_tab_index_in_tab_bar = false,
   switch_to_last_active_tab_when_closing_tab = true,

   -- window
   window_padding = {
      left = 4,
      right = 4,
      top = 4,
      bottom = 4,
   },
   automatically_reload_config = true,
   inactive_pane_hsb = { saturation = 1.0, brightness = 1.0 },
   window_background_opacity = 1.0,
   window_close_confirmation = "NeverPrompt",

   -- mousebindings
   mouse_bindings = {
      -- Ctrl-click will open the link under the mouse cursor
      {
         event = { Up = { streak = 1, button = "Left" } },
         mods = "CTRL",
         action = wezterm.action.OpenLinkAtMouseCursor,
      },
   },

   -- others
   force_reverse_video_cursor = true
}
