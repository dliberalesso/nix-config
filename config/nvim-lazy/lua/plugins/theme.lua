local enabled = true

if not enabled then
  return {}
end

return {
  -- Configure LazyVim to load catppuccin
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "catppuccin" },
  },
  -- Configure catppuccin
  {
    "catppuccin/nvim",
    name = "catppuccin",

    dependencies = {
      {
        "rachartier/tiny-devicons-auto-colors.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
      },
    },

    event = "User LazyColorscheme",

    config = function(_, opts)
      require("catppuccin").setup(opts)

      require("tiny-devicons-auto-colors").setup {
        colors = require("catppuccin.palettes").get_palette(opts.flavour),
      }
    end,

    opts = { flavour = "mocha" },
  },
  -- Configure kanagawa
  {
    "rebelot/kanagawa.nvim",
    event = "User LazyColorscheme",
  },
  -- Coonfigure nightfox
  {
    "EdenEast/nightfox.nvim",
    event = "User LazyColorscheme",
  },
  -- Configure rose-pine
  {
    "rose-pine/neovim",
    name = "rose-pine",
    event = "User LazyColorscheme",
  },
  -- Configure tokyonight
  {
    "folke/tokyonight.nvim",
    event = "User LazyColorscheme",
  },
}
