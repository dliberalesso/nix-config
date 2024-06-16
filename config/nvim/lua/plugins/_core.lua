local core_spec = require("core.utils").core_spec

---@type LazySpec[]
return {
  core_spec("init", {
    event = "VeryLazy",
    priority = -10000,

    init = function()
      require("core.init").init()
    end,
  }),
  core_spec("settings", {
    event = "VimEnter",
  }),
  core_spec("mappings", {
    event = "VeryLazy",
    priority = 10000,
    opts = require("core.utils").empty_map_table(),
  }),
}
