require("lazy").setup({
  {
    "AstroNvim/AstroNvim",
    import = "astronvim.plugins",
    opts = { -- AstroNvim options must be set here with the `import` key
      mapleader = " ", -- This ensures the leader key must be configured before Lazy is set up
      maplocalleader = ",", -- This ensures the localleader key must be configured before Lazy is set up
      icons_enabled = true, -- Set to false to disable icons (if no Nerd Font is available)
    },
  },
  { import = "community" },
  { import = "plugins" },
  { import = "mappings" },
} --[[@as LazySpec]], {
  local_spec = true, -- load project specific .lazy.lua spec files. They will be added at the end of the spec.
  defaults = { lazy = true },
  dev = {
    path = vim.fn.stdpath "data" .. "/nixpkgs",
    -- patterns = { "." },
    fallback = false,
  },
  install = { colorscheme = { "catppuccin", "astrodark", "habamax" } },
  ui = { backdrop = 100 },
  performance = {
    rtp = {
      -- disable some rtp plugins, add more to your liking
      disabled_plugins = {
        "netrw",
        "netrwPlugin",
        "netrwSettings",
        "netrwFileHandlers",
        "gzip",
        "zip",
        "zipPlugin",
        "tar",
        "tarPlugin",
        "getscript",
        "getscriptPlugin",
        "vimball",
        "vimballPlugin",
        "2html_plugin",
        "tohtml",
        "logipat",
        "rrhelper",
        "spellfile_plugin",
        "matchit",
        "tutor",
        "rplugin",
        "syntax",
        "synmenu",
        "optwin",
        "compiler",
        "bugreport",
        "ftplugin",
      },
    },
  },
} --[[@as LazyConfig]])
