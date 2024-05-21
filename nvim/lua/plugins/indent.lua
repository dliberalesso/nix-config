return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      scope = { enabled = false },
    },
  },
  {
    "echasnovski/mini.indentscope",
    event = { "BufReadPre", "BufNewFile" },
    config = true,
  },
  {
    "nmac427/guess-indent.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = true,
  },
}
