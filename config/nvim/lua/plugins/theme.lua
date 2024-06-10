---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.colorscheme.catppuccin" },
  { import = "astrocommunity.colorscheme.kanagawa-nvim" },
  { import = "astrocommunity.colorscheme.rose-pine" },
  { import = "astrocommunity.colorscheme.tokyonight-nvim" },

  {
    "AstroNvim/astroui",
    ---@type AstroUIOpts
    opts = {
      colorscheme = "catppuccin",
    },
  },

  { "AstroNvim/astrotheme", event = "User LazyColorscheme" },
  { "catppuccin/nvim", name = "catppuccin", event = "User LazyColorscheme" },
  { "rebelot/kanagawa.nvim", event = "User LazyColorscheme" },
  { "rose-pine/neovim", name = "rose-pine", event = "User LazyColorscheme" },
  { "folke/tokyonight.nvim", event = "User LazyColorscheme" },

  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      mappings = {
        n = {
          ["<Leader>ft"] = {
            function()
              -- Trigger the User LazyColorscheme event
              vim.cmd.doautocmd "User LazyColorscheme"
              -- Then open the colorscheme picker
              require("telescope.builtin").colorscheme { enable_preview = true }
            end,
            desc = "Find themes",
          },
        },
      },
    },
  },
}
