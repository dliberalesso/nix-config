---@type LazySpec
return {
  "folke/todo-comments.nvim",
  cmd = { "TodoTrouble", "TodoTelescope", "TodoLocList", "TodoQuickFix" },
  event = "User AstroFile",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "AstroNvim/astrocore",
      opts = function(_, opts)
        local maps = opts.mappings
        -- TODO: set this keymaps using `lazy.nvim` keys
        if require("astrocore").is_available("telescope.nvim") then
          maps.n["<Leader>fT"] = { "<Cmd>TodoTelescope<CR>", desc = "Find TODOs" }
        end
        -- TODO: set the following keymaps during config
        maps.n["]T"] = {
          function()
            require("todo-comments").jump_next()
          end,
          desc = "Next TODO comment",
        }
        maps.n["[T"] = {
          function()
            require("todo-comments").jump_prev()
          end,
          desc = "Previous TODO comment",
        }
      end,
    },
  },
  opts = {},
}
