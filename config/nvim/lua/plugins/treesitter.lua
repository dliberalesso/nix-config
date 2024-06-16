---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  main = "nvim-treesitter.configs",

  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    "windwp/nvim-ts-autotag",
    "hiphish/rainbow-delimiters.nvim",
  },

  -- TODO: add a custom event like
  -- event = "User AstroFile",
  event = { "BufReadPost", "BufNewFile" },

  cmd = {
    "TSInstallSync",
    "TSUpdate",
    "TSUpdateSync",
  },

  build = ":TSUpdate",

  init = function(plugin)
    -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
    require("lazy.core.loader").add_to_rtp(plugin)
    pcall(require, "nvim-treesitter.query_predicates")

    -- INFO: add command for installing parsers without opening nvim
    -- `nvim --headless "+HeadlessTSUpdate" +qa`
    vim.api.nvim_create_user_command("HeadlessTSUpdate", function()
      local lazy_plugin = require("lazy.core.plugin")
      local opts = lazy_plugin.values(plugin, "opts", false)
      local ensure_installed = opts.ensure_installed

      vim.cmd({
        cmd = "TSUpdateSync",
        args = ensure_installed,
      })
    end, { desc = "Install treesitter parsers declared in `ensure_installed`" })
  end,

  config = function(plugin, opts)
    local ts = require(plugin.main)

    ---@param bufnr integer
    ---@return boolean
    local is_large_buf = function(bufnr)
      -- HACK: for now, set limits for large files here
      local large_buf = { size = 1024 * 256, lines = 10000 }

      return (vim.fn.getfsize(vim.api.nvim_buf_get_name(bufnr)) > large_buf.size)
        or (vim.api.nvim_buf_line_count(bufnr) > large_buf.size)
    end

    -- disable all treesitter modules on large buffer
    for _, module in ipairs(ts.available_modules()) do
      if not opts[module] then
        opts[module] = {}
      end
      local module_opts = opts[module]
      local disable = module_opts.disable
      module_opts.disable = function(lang, bufnr)
        return (type(disable) == "table" and vim.tbl_contains(disable, lang))
          or is_large_buf(bufnr)
          or (type(disable) == "function" and disable(lang, bufnr))
      end
    end

    ts.setup(opts)
  end,

  opts_extend = { "ensure_installed" },
  opts = {
    auto_install = true,
    ensure_installed = {
      "bash",
      "c",
      "diff",
      "fish",
      "gitcommit",
      "html",
      "javascript",
      "jsdoc",
      "json",
      "jsonc",
      "just",
      "lua",
      "luadoc",
      "luap",
      "markdown",
      "markdown_inline",
      "nix",
      "printf",
      "python",
      "query",
      "regex",
      "toml",
      "tsx",
      "vim",
      "vimdoc",
      "xml",
      "yaml",
    },
    autotag = { enable = true },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    incremental_selection = { enable = true },
    indent = { enable = true },
    matchup = {
      enable = true,
      enable_quotes = true,
      disable = { "c" }, -- disabled for slow parsers
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["ak"] = { query = "@block.outer", desc = "around block" },
          ["ik"] = { query = "@block.inner", desc = "inside block" },
          ["ac"] = { query = "@class.outer", desc = "around class" },
          ["ic"] = { query = "@class.inner", desc = "inside class" },
          ["a?"] = { query = "@conditional.outer", desc = "around conditional" },
          ["i?"] = { query = "@conditional.inner", desc = "inside conditional" },
          ["af"] = { query = "@function.outer", desc = "around function " },
          ["if"] = { query = "@function.inner", desc = "inside function " },
          ["ao"] = { query = "@loop.outer", desc = "around loop" },
          ["io"] = { query = "@loop.inner", desc = "inside loop" },
          ["aa"] = { query = "@parameter.outer", desc = "around argument" },
          ["ia"] = { query = "@parameter.inner", desc = "inside argument" },
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          ["]k"] = { query = "@block.outer", desc = "Next block start" },
          ["]f"] = { query = "@function.outer", desc = "Next function start" },
          ["]a"] = { query = "@parameter.inner", desc = "Next argument start" },
        },
        goto_next_end = {
          ["]K"] = { query = "@block.outer", desc = "Next block end" },
          ["]F"] = { query = "@function.outer", desc = "Next function end" },
          ["]A"] = { query = "@parameter.inner", desc = "Next argument end" },
        },
        goto_previous_start = {
          ["[k"] = { query = "@block.outer", desc = "Previous block start" },
          ["[f"] = { query = "@function.outer", desc = "Previous function start" },
          ["[a"] = { query = "@parameter.inner", desc = "Previous argument start" },
        },
        goto_previous_end = {
          ["[K"] = { query = "@block.outer", desc = "Previous block end" },
          ["[F"] = { query = "@function.outer", desc = "Previous function end" },
          ["[A"] = { query = "@parameter.inner", desc = "Previous argument end" },
        },
      },
      swap = {
        enable = true,
        swap_next = {
          [">K"] = { query = "@block.outer", desc = "Swap next block" },
          [">F"] = { query = "@function.outer", desc = "Swap next function" },
          [">A"] = { query = "@parameter.inner", desc = "Swap next argument" },
        },
        swap_previous = {
          ["<K"] = { query = "@block.outer", desc = "Swap previous block" },
          ["<F"] = { query = "@function.outer", desc = "Swap previous function" },
          ["<A"] = { query = "@parameter.inner", desc = "Swap previous argument" },
        },
      },
    },
  },
}
