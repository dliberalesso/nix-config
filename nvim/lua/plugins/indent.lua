local enabled = true

local M = {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = { scope = { enabled = false } },
  },
  {
    "echasnovski/mini.indentscope",
    event = { "BufReadPost", "BufNewFile" },
    config = true,
  },
  {
    "nmac427/guess-indent.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = true,
  },
}

return enabled and M or {}
