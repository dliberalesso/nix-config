return {
  {
    "rebelot/heirline.nvim",

    dependencies = {
      "rachartier/tiny-devicons-auto-colors.nvim",
      "zeioth/heirline-components.nvim",
    },

    event = "VeryLazy",

    opts = function()
      local lib = require "heirline-components.all"

      return {
        -- opts = {
        --   disable_winbar_cb = function(args) -- We do this to avoid showing it on the greeter.
        --     local is_disabled = not require("heirline-components.buffer").is_valid(args.buf)
        --       or lib.condition.buffer_matches({
        --         buftype = { "terminal", "prompt", "nofile", "help", "quickfix" },
        --         filetype = { "NvimTree", "neo%-tree", "dashboard", "Outline", "aerial" },
        --       }, args.buf)
        --     return is_disabled
        --   end,
        -- },
        --
        -- tabline = { -- UI upper bar
        --   lib.component.tabline_conditional_padding(),
        --   lib.component.tabline_buffers(),
        --   lib.component.fill { hl = { bg = "tabline_bg" } },
        --   lib.component.tabline_tabpages(),
        -- },
        --
        -- winbar = { -- UI breadcrumbs bar
        --   init = function(self)
        --     self.bufnr = vim.api.nvim_get_current_buf()
        --   end,
        --   fallthrough = false,
        --   -- Winbar for terminal, neotree, and aerial.
        --   {
        --     condition = function()
        --       return not lib.condition.is_active()
        --     end,
        --     {
        --       lib.component.neotree(),
        --       lib.component.compiler_play(),
        --       lib.component.fill(),
        --       lib.component.compiler_redo(),
        --       lib.component.aerial(),
        --     },
        --   },
        --   -- Regular winbar
        --   {
        --     lib.component.neotree(),
        --     lib.component.compiler_play(),
        --     lib.component.fill(),
        --     lib.component.breadcrumbs(),
        --     lib.component.fill(),
        --     lib.component.compiler_redo(),
        --     lib.component.aerial(),
        --   },
        -- },

        statuscolumn = { -- UI left column
          init = function(self)
            self.bufnr = vim.api.nvim_get_current_buf()
          end,
          lib.component.foldcolumn(),
          lib.component.numbercolumn(),
          lib.component.signcolumn(),
        } or nil,

        statusline = { -- UI statusbar
          hl = { fg = "fg", bg = "bg" },
          lib.component.mode { mode_text = {} },
          lib.component.git_branch(),
          lib.component.file_info(),
          lib.component.fill(),
          lib.component.cmd_info(),
          lib.component.fill(),
          lib.component.lsp(),
          lib.component.compiler_state(),
          lib.component.virtual_env(),
          lib.component.nav(),
          lib.component.mode { mode_text = {}, surround = { separator = "right" } },
        },
      }
    end,

    config = function(_, opts)
      local heirline = require "heirline"
      local heirline_components = require "heirline-components.all"

      -- Setup
      heirline_components.init.subscribe_to_events()
      heirline.load_colors(heirline_components.hl.get_colors())
      heirline.setup(opts)
    end,
  },
}
