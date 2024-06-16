local utils = require("core.utils")
local plugin = utils.get_plugin("core")
local opts = utils.plugin_opts("core")

vim.notify(vim.inspect(plugin))
