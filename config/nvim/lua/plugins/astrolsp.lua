return {
  "AstroNvim/astrolsp",

  dependencies = { "b0o/SchemaStore.nvim" },

  -- we must use the function override because table merging
  -- does not play nicely with list-like tables
  ---@param opts AstroLSPOpts
  opts = function(_, opts)
    -- safely extend the config list
    opts.config = opts.config or {}
    vim.list_extend(opts.config, {
      jsonls = {
        on_new_config = function(config)
          if not config.settings.json.schemas then
            config.settings.json.schemas = {}
          end
          vim.list_extend(config.settings.json.schemas, require("schemastore").json.schemas())
        end,
        settings = { json = { validate = { enable = true } } },
      },

      lua_ls = { settings = { Lua = { hint = { enable = true, arrayIndex = "Disable" } } } },

      yamlls = {
        on_new_config = function(config)
          if not config.settings.yaml.schemas then
            config.settings.yaml.schemas = {}
          end
          vim.list_extend(config.settings.yaml.schemas, require("schemastore").yaml.schemas())
        end,
        settings = { yaml = { schemaStore = { enable = false, url = "" } } },
      },
    })

    -- safely extend the servers list
    opts.servers = opts.servers or {}
    vim.list_extend(opts.servers, {
      "jsonls",
      "lua_ls",
      "marksman",
      "nixd",
      "taplo",
      "yamlls",
    })
  end,
}
