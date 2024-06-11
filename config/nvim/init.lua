-- Loading shada is SLOW
-- Let's load it after UI-enter so it doesn't block startup.
-- See lua/core/astrocore_autocmds.lua
_G.shada = vim.o.shada
vim.o.shada = ""

vim.loader.enable()

-- require("utils.notify").init()

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

vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.g.icons_enabled = true

---@type LazySpec
local spec = {
  { "folke/lazy.nvim", dir = vim.env.LAZY },
  { import = "core" },
  { import = "plugins" },
}

---@type LazyConfig
local config = {
  local_spec = true, -- load project specific .lazy.lua spec files. They will be added at the end of the spec.
  defaults = { lazy = true },
  install = { colorscheme = { "catppuccin", "astrodark", "habamax" } },
  ui = { backdrop = 100 },
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
      },
    },
  },
}

require("lazy").setup(spec, config)
