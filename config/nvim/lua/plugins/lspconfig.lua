return {
  "neovim/nvim-lspconfig",
  dependencies = {
    {
      "AstroNvim/astrolsp",
      opts = function(_, opts)
        local maps = opts.mappings
        maps.n["<Leader>li"] = {
          "<Cmd>LspInfo<CR>",
          desc = "LSP information",
          cond = function()
            return vim.fn.exists ":LspInfo" > 0
          end,
        }
      end,
    },
    { "folke/neoconf.nvim", lazy = true, opts = {} },
  },
  cmd = function(_, cmds) -- HACK: lazy load lspconfig on `:Neoconf` if neoconf is available
    if require("astrocore").is_available "neoconf.nvim" then
      table.insert(cmds, "Neoconf")
    end
    vim.list_extend(cmds, { "LspInfo", "LspLog", "LspStart" }) -- add normal `nvim-lspconfig` commands
  end,
  event = "User AstroFile",
  config = function(_, _)
    local setup_servers = function()
      vim.tbl_map(require("astrolsp").lsp_setup, require("astrolsp").config.servers)
      require("astrocore").exec_buffer_autocmds("FileType", { group = "lspconfig" })

      require("astrocore").event "LspSetup"
    end
    local astrocore = require "astrocore"
    setup_servers()
  end,
}
