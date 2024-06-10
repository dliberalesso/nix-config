---@type LazySpec
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "fish", "json", "jsonc", "just", "nix", "toml", "yaml" },
      auto_install = true,
      highlight = {
        additional_vim_regex_highlighting = false,
      },
    },
  },
  {
    "AstroNvim/astrocore",

    opts = {
      commands = {
        HeadlessTSUpdate = {
          function()
            local astrocore = require "astrocore"
            local opts = astrocore.plugin_opts "nvim-treesitter"
            local ensure_installed = opts.ensure_installed

            vim.cmd.TSUpdateSync(ensure_installed)
          end,
          desc = "Install treesitter parsers declared in `ensure_installed`",
        },
      },
    },
  },
}
