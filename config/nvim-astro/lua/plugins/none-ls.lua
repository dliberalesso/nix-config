---@type LazySpec
return {
  "nvimtools/none-ls.nvim",
  main = "null-ls",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "AstroNvim/astrolsp",
      opts = function(_, opts)
        local maps = opts.mappings
        maps.n["<Leader>lI"] = {
          "<Cmd>NullLsInfo<CR>",
          desc = "Null-ls information",
          cond = function()
            return vim.fn.exists(":NullLsInfo") > 0
          end,
        }
      end,
    },
  },
  event = "User AstroFile",
  opts = function()
    local null_ls = require("null-ls")
    return {
      on_attach = require("astrolsp").on_attach,
      sources = {
        -- fish
        null_ls.builtins.diagnostics.fish,
        null_ls.builtins.formatting.fish_indent,

        -- javascript, markdown, css, html...
        null_ls.builtins.formatting.prettierd,

        -- lua
        null_ls.builtins.diagnostics.selene,
        null_ls.builtins.formatting.stylua,

        -- nix
        null_ls.builtins.diagnostics.deadnix,
        null_ls.builtins.diagnostics.statix,
        null_ls.builtins.formatting.nixpkgs_fmt,

        -- sh
        null_ls.builtins.formatting.shfmt,
      },
    }
  end,
}
