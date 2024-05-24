return {
  "nvim-treesitter/nvim-treesitter",

  event = { "BufReadPost", "BufNewFile" },

  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    "hiphish/rainbow-delimiters.nvim",
  },

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
