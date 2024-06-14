vim.loader.enable()

vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.g.icons_enabled = true

local confpath = vim.fn.stdpath "config" --[[@as string]]
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim" --[[@as string]]

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end

vim.opt.rtp:prepend(lazypath)

---@type LazySpec[]
local spec = {
  {
    main = "utils.shada",
    name = "utils.shada",
    dir = confpath,
    event = "VeryLazy",
    init = function()
      require("utils.shada").init(vim.o.shada)
    end,
    config = true,
  },
  { import = "plugins" },
}

---@type LazyConfig
local config = {
  local_spec = true, -- load project specific .lazy.lua spec files. They will be added at the end of the spec.
  defaults = { lazy = true, version = false },
  install = { colorscheme = { "catppuccin", "habamax" } },
  ui = { backdrop = 100 },
  diff = { cmd = "diffview.nvim" },
  performance = {
    rtp = {
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
        "matchparen",
        "spellfile",
        "osc52", -- Wezterm doesn't support osc52 yet
      },
    },
  },
}

require("lazy").setup(spec, config)
