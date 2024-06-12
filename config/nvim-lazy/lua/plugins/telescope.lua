local enabled = true

if not enabled then
  return {}
end

return {
  "nvim-telescope/telescope.nvim",

  dependencies = {
    {
      "debugloop/telescope-undo.nvim",

      config = function()
        LazyVim.on_load("telescope.nvim", function()
          require("telescope").load_extension "undo"
        end)
      end,
    },
  },

  keys = {
    { "<leader>fu", "<cmd>Telescope undo<cr>", desc = "Find in undo tree" },
    {
      "<leader>uC",
      function()
        -- Trigger the User LazyColorscheme event
        vim.cmd.doautocmd "User LazyColorscheme"
        -- Then open the colorscheme picker
        require("telescope.builtin").colorscheme { enable_preview = true }
      end,
      desc = "Colorscheme with Preview",
    },
  },

  opts = {
    defaults = {
      layout_config = {
        horizontal = {
          prompt_position = "top",
          preview_width = 0.50,
        },
        vertical = {
          mirror = false,
        },
        width = 0.87,
        height = 0.80,
        preview_cutoff = 120,
      },
    },

    extensions = {
      undo = {
        side_by_side = true,
        diff_context_lines = 0,
        entry_format = "󰣜 #$ID, $STAT, $TIME",
        layout_strategy = "horizontal",

        layout_config = {
          preview_width = 0.65,
        },

        mappings = {
          i = {
            ["<C-y>"] = false,
            ["<C-r>"] = false,
          },
        },
      },
    },
  },
}
