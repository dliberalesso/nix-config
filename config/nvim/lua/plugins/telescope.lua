local enabled = true

if not enabled then
  return {}
end

return {
  "nvim-telescope/telescope.nvim",

  dependencies = {
    "nvim-lua/plenary.nvim",

    -- Telescope extensions
    { "nvim-telescope/telescope-fzf-native.nvim", dev = true }, -- dev because of Nix
    "debugloop/telescope-undo.nvim",
  },

  cmd = "Telescope",

  keys = {
    {
      "<leader><leader>",
      "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",
      desc = "Switch Buffers",
    },
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    { "<leader>fu", "<cmd>Telescope undo<cr>", desc = "Find in undo tree" },
  },

  config = function(_, opts)
    local telescope = require "telescope"

    telescope.setup(opts)

    -- Load extensions
    pcall(telescope.load_extension, "fzf")
    pcall(telescope.load_extension, "notify")
    pcall(telescope.load_extension, "undo")
  end,

  opts = function()
    local get_icon = require("icons").get_icon

    local actions = require "telescope.actions"
    local mappings = {
      i = {
        ["<C-n>"] = actions.cycle_history_next,
        ["<C-p>"] = actions.cycle_history_prev,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<ESC>"] = actions.close,
        ["<C-c>"] = false,
      },
      n = { ["q"] = actions.close },
    }

    return {
      defaults = {
        prompt_prefix = get_icon("PromptPrefix", 1),
        selection_caret = get_icon("Selected", 1),
        path_display = { "truncate" },
        sorting_strategy = "ascending",

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

        mappings = mappings,
      },

      extensions = {
        undo = {
          use_delta = true,
          side_by_side = true,
          diff_context_lines = 0,
          entry_format = "󰣜 #$ID, $STAT, $TIME",
          layout_strategy = "horizontal",

          layout_config = {
            preview_width = 0.65,
          },

          mappings = {
            i = {
              ["<cr>"] = require("telescope-undo.actions").yank_additions,
              ["<S-cr>"] = require("telescope-undo.actions").yank_deletions,
              ["<C-cr>"] = require("telescope-undo.actions").restore,
            },
          },
        },
      },
    }
  end,
}
