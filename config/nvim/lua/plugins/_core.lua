local core_spec = require("core.utils").core_spec

---@type LazySpec[]
return {
  core_spec("notify", {
    init = function()
      require("core.notify").init()
    end,
  }),
  core_spec("settings", {
    event = "VimEnter",
  }),
  core_spec("mappings", {
    event = "VeryLazy",
    opts = require("core.utils").empty_map_table(),
  }),
  core_spec("shada", {
    event = "VeryLazy",
  }),
}
