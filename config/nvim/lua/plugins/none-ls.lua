return {
  "nvimtools/none-ls.nvim",
  main = "null-ls",
  dependencies = {
    { "nvim-lua/plenary.nvim", lazy = true },
    {
      "AstroNvim/astrolsp",
      opts = function(_, opts)
        local maps = opts.mappings
        maps.n["<Leader>lI"] = {
          "<Cmd>NullLsInfo<CR>",
          desc = "Null-ls information",
          cond = function()
            return vim.fn.exists ":NullLsInfo" > 0
          end,
        }
      end,
    },
  },
  event = "User AstroFile",
  opts = function()
    return { on_attach = require("astrolsp").on_attach }
  end,
}
