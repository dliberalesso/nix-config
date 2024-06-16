local M = {}

---@param core_module string
---@param rest table
---@return LazySpec
function M.core_spec(core_module, rest)
  local name = "core." .. core_module
  return vim.tbl_extend("force", {
    name = name,
    main = name,
    dir = vim.fn.stdpath("config"), --[[@as string]]
  }, rest)
end

-- Get an empty table of mappings with a key for each map mode
---@return table<string,table> # a table with entries for each map mode
function M.empty_map_table()
  local maps = {}

  -- stylua: ignore
  for _, mode in ipairs {
    "", "n", "v", "x", "s", "o", "!", "i", "l", "c", "t", "ia", "ca", "!a"
  } do
    maps[mode] = {}
  end

  return maps
end

-- Set a table of mappings.
---@param map_table table A nested table where the first key is the vim mode,
---                       the second key is the key to map, and the value is
---                       the function to set the mapping to.
---@param base? table A base set of options to set on every keybinding.
function M.set_mappings(map_table, base)
  -- iterate over the first keys for each mode
  for mode, maps in pairs(map_table) do
    -- iterate over each keybinding set in the current mode
    for keymap, options in pairs(maps) do
      -- build the options for the command accordingly
      if options then
        local cmd = options
        local keymap_opts = base or {}
        if type(options) == "table" then
          cmd = options[1]
          keymap_opts = vim.tbl_deep_extend("force", keymap_opts, options)
          keymap_opts[1] = nil
        end
        vim.keymap.set(mode, keymap, cmd, keymap_opts)
      end
    end
  end
end

-- Get a plugin spec from lazy
---@param plugin string The plugin to search for
---@return LazyPlugin? available # The found plugin spec from Lazy
function M.get_plugin(plugin)
  local lazy_config_avail, lazy_config = pcall(require, "lazy.core.config")
  return lazy_config_avail and lazy_config.spec.plugins[plugin] or nil
end

-- Resolve the options table for a given plugin with lazy
---@param plugin string The plugin to search for
---@return table opts # The plugin options
function M.plugin_opts(plugin)
  local spec = M.get_plugin(plugin)
  return spec and require("lazy.core.plugin").values(spec, "opts") or {}
end

return M
