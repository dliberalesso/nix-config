local wezterm = require("wezterm") --[[@as Wezterm]]

local config = wezterm.config_builder()

config.color_scheme = "Catppuccin Mocha"
config.default_domain = "WSL:NixOS"
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
