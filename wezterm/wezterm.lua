local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "Tokyo Night Storm"
config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 17

config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.default_cursor_style = "BlinkingBar"
config.window_decorations = "RESIZE"

config.window_background_opacity = 0.9
config.macos_window_background_blur = 10

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

config.prefer_egl = true

return config
