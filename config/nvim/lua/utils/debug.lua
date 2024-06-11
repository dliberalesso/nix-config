local astrocore = require "astrocore"
local opts = astrocore.plugin_opts "nvim-treesitter"
local ensure_installed = opts.ensure_installed

astrocore.notify(vim.inspect(ensure_installed))
