local wezterm = require("wezterm") --[[@as Wezterm]]

---@class Config
local config = wezterm.config_builder()

local catppuccin_url = "https://github.com/catppuccin/wezterm"
local catppuccin_plugin = wezterm.plugin.require(catppuccin_url)

catppuccin_plugin.apply_to_config(config)

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  config.default_domain = "WSL:NixOS"
  config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
end

config.use_fancy_tab_bar = false
config.default_cursor_style = "SteadyBar"

config.font_size = 12
config.warn_about_missing_glyphs = true

config.freetype_load_target = "HorizontalLcd" -- https://wezfurlong.org/wezterm/config/lua/config/freetype_load_target.html

-- Monaspace:  https://monaspace.githubnext.com/
local hbf = { "calt", "liga", "dlig", "ss01", "ss02", "ss03", "ss04", "ss05", "ss06", "ss07", "ss08" }

config.font = wezterm.font({ -- Normal text
  family = "Monaspace Neon",
  harfbuzz_features = hbf,
  stretch = "UltraCondensed", -- This doesn't seem to do anything
})

config.font_rules = {
  { -- Italic
    intensity = "Normal",
    italic = true,
    font = wezterm.font({
      family = "Monaspace Xenon", -- courier-like
      style = "Italic",
      harfbuzz_features = hbf,
    }),
  },

  { -- Bold
    intensity = "Bold",
    italic = false,
    font = wezterm.font({
      family = "Monaspace Krypton",
      weight = "Bold",
      harfbuzz_features = hbf,
    }),
  },

  { -- Bold Italic
    intensity = "Bold",
    italic = true,
    font = wezterm.font({
      family = "Monaspace Xenon",
      style = "Italic",
      weight = "Bold",
      harfbuzz_features = hbf,
    }),
  },
}

return config
