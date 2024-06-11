return {
  {
    "nvim-telescope/telescope.nvim",

    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "AstroNvim/astrocore",
      "AstroNvim/astroui",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },

    cmd = "Telescope",

    keys = function()
      local _map = function(key, map, desc)
        return { "<leader>" .. key, map, desc = desc }
      end

      local map_builtin = function(lhs, builtin, desc, args)
        args = args or {}
        return _map(lhs, function()
          require("telescope.builtin")[builtin](args)
        end, desc)
      end

      local map_extension = function(lhs, extension, desc)
        return _map(lhs, function()
          local telescope = require "telescope"
          telescope.load_extension(extension)
          telescope.extensions[extension][extension]()
        end, desc)
      end

      ---@type LazyKeysSpec[]
      return {
        map_builtin("f<CR>", "resume", "Resume previous search"),
        map_builtin("f'", "marks", "Find marks"),
        map_builtin("f/", "current_buffer_fuzzy_find", "Find words in current buffer"),
        map_builtin("fa", "find_files", "Find AstroNvim config files", {
          prompt_title = "Config Files",
          cwd = vim.fn.stdpath "config",
          follow = true,
        }),
        map_builtin("fb", "buffers", "Find buffers"),
        map_builtin("fc", "grep_string", "Find word under cursor"),
        map_builtin("fC", "commands", "Find commands"),
        map_builtin("ff", "find_files", "Find files"),
        map_builtin("fF", "find_files", "Find all files", { hidden = true, no_ignore = true }),
        map_builtin("fh", "help_tags", "Find help"),
        map_builtin("fk", "keymaps", "Find keymaps"),
        map_builtin("fm", "man_pages", "Find man"),
        map_extension("fn", "notify", "Find notifications"),
        map_builtin("fo", "oldfiles", "Find history"),
        map_builtin("fr", "registers", "Find registers"),
        map_builtin("ft", "colorscheme", "Find themes", { enable_preview = true }),
        map_builtin("fw", "live_grep", "Find words"),
        map_builtin("fW", "live_grep", "Find words in all files", {
          additional_args = function(args)
            return vim.list_extend(args, { "--hidden", "--no-ignore" })
          end,
        }),
        map_builtin("gb", "git_branches", "Git branches", { use_file_path = true }),
        map_builtin("gc", "git_commits", "Git commits (repository)", { use_file_path = true }),
        map_builtin("gC", "git_bcommits", "Git commits (current file)", { use_file_path = true }),
        map_builtin("gt", "git_status", "Git status", { use_file_path = true }),
        map_extension("ls", "aerial", "Search symbols"),
      }
    end,

    opts = function()
      local actions = require "telescope.actions"
      local selected_icon = require("astroui").get_icon("Selected", 1)
      return {
        defaults = {
          git_worktrees = require("astrocore").config.git_worktrees,
          prompt_prefix = selected_icon,
          selection_caret = selected_icon,
          multi_icon = selected_icon,
          path_display = { "truncate" },
          sorting_strategy = "ascending",
          layout_config = {
            horizontal = { prompt_position = "top", preview_width = 0.55 },
            vertical = { mirror = false },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          mappings = {
            i = {
              ["<C-N>"] = actions.cycle_history_next,
              ["<C-P>"] = actions.cycle_history_prev,
              ["<C-J>"] = actions.move_selection_next,
              ["<C-K>"] = actions.move_selection_previous,
            },
            n = { q = actions.close },
          },
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
      }
    end,
    config = function(_, opts)
      local telescope = require "telescope"
      telescope.setup(opts)
      telescope.load_extension "fzf"
    end,
  },
  {
    "AstroNvim/astrolsp",
    optional = true,
    opts = function(_, opts)
      local maps = opts.mappings
      maps.n["<Leader>lD"] = {
        function()
          require("telescope.builtin").diagnostics()
        end,
        desc = "Search diagnostics",
      }
      if maps.n.gd then
        maps.n.gd[1] = function()
          require("telescope.builtin").lsp_definitions { reuse_win = true }
        end
      end
      if maps.n.gI then
        maps.n.gI[1] = function()
          require("telescope.builtin").lsp_implementations { reuse_win = true }
        end
      end
      if maps.n["<Leader>lR"] then
        maps.n["<Leader>lR"][1] = function()
          require("telescope.builtin").lsp_references()
        end
      end
      if maps.n.gy then
        maps.n.gy[1] = function()
          require("telescope.builtin").lsp_type_definitions { reuse_win = true }
        end
      end
      if maps.n["<Leader>lG"] then
        maps.n["<Leader>lG"][1] = function()
          vim.ui.input({ prompt = "Symbol Query: (leave empty for word under cursor)" }, function(query)
            if query then
              -- word under cursor if given query is empty
              if query == "" then
                query = vim.fn.expand "<cword>"
              end
              require("telescope.builtin").lsp_workspace_symbols {
                query = query,
                prompt_title = ("Find word (%s)"):format(query),
              }
            end
          end)
        end
      end
    end,
  },
}
