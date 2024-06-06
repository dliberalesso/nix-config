local plugin = require("lazy.core.config").spec.plugins["inc-rename.nvim"]
local opts = require("lazy.core.plugin").values(plugin, "opts", false)

print(vim.inspect(plugin))
