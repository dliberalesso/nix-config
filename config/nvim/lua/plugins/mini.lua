local enabled = true

if not enabled then
  return {}
end

return {
  {
    "echasnovski/mini.basics",
    lazy = false,
    opts = {
      options = { win_borders = "bold" },
      mappings = {
        option_toggle_prefix = [[<leader>u]],
        windows = true,
        move_with_alt = true,
      },
    },
  },
  {
    "echasnovski/mini.ai",
    event = { "BufReadPost", "BufNewFile" },
    opts = { n_lines = 500 },
  },
  {
    "echasnovski/mini.align",
    event = { "BufReadPost", "BufNewFile" },
    config = true,
  },
  {
    "echasnovski/mini.pairs",
    event = { "BufReadPost", "BufNewFile" },
    config = true,
  },
  {
    "echasnovski/mini.surround",
    event = { "BufReadPost", "BufNewFile" },
    config = true,
  },
  {
    "echasnovski/mini.trailspace",
    event = { "BufReadPost", "BufNewFile" },
    config = true,
  },
}
