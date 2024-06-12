local enabled = true

if not enabled then
  return {}
end

return {
  "nvim-treesitter/nvim-treesitter",

  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    "hiphish/rainbow-delimiters.nvim",
  },

  event = { "BufReadPost", "BufNewFile" },

  config = function()
    require("nvim-treesitter.configs").setup {
      ensure_installed = {},
      auto_install = false,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
    }
  end,
}
