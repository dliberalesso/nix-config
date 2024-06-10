---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = { "fish", "json", "jsonc", "just", "nix", "toml", "yaml" },
    auto_install = true,
    highlight = {
      additional_vim_regex_highlighting = false,
    },
  },
}
