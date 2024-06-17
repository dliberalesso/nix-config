local core_spec = require("core.utils").core_spec

---@type LazySpec[]
return {
  core_spec("autocmds", {
    event = "VeryLazy",
  }),
  core_spec("mappings", {
    event = "VeryLazy",
    opts = require("core.utils").empty_map_table(),
  }),
  core_spec("notify", {
    init = function()
      require("core.notify").init()
    end,
    config = nil,
  }),
  core_spec("settings", {
    event = "VimEnter",
  }),
  core_spec("shada", {
    event = "VeryLazy",
  }),
}
