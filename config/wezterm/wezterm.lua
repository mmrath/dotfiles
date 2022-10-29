local wezterm = require("wezterm")
require("config.right-status").setup()
require("config.notify").setup()
require("config.tab-title").setup()

local font_name = "Iosevka Nerd Font"

local function font(name, params)
   return wezterm.font(name, params)
end

return {
	-- font
	font = wezterm.font_with_fallback({
 		"Iosevka Nerd Font",
		"JetBrains Mono",
		"nonicons",
	}),
	font_size = 14.0,
	line_height = 1.1,
  -- colorscheme
  color_scheme = "GitHub Dark",

  -- scroll bar
  enable_scroll_bar = true,

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
      left = 5,
      right = 10,
      top = 12,
      bottom = 12,
   },
   automatically_reload_config = true,
   inactive_pane_hsb = { saturation = 1.0, brightness = 1.0 },
   window_background_opacity = 1.0,
   window_close_confirmation = "NeverPrompt",
   window_frame = {
      active_titlebar_bg = "#090909",
      font = font(font_name, { bold = true }),
      font_size = 9,
   },

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
  force_reverse_video_cursor = true,
}
