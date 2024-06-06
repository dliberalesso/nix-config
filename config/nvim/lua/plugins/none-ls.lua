-- Customize None-ls sources

---@type LazySpec
return {
  "nvimtools/none-ls.nvim",
  opts = function(_, config)
    -- config variable is the default configuration table for the setup function call
    local null_ls = require "null-ls"

    -- Check supported formatters and linters
    -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/formatting
    -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
    config.sources = {
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
    }
    return config -- return final config table
  end,
}
