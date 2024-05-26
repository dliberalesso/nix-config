return {
  {
    "b0o/incline.nvim",

    event = { "BufReadPre", "BufNewFile" },

    dependencies = { "rachartier/tiny-devicons-auto-colors.nvim" },

    config = function()
      local devicons = require "nvim-web-devicons"

      require("incline").setup {
        window = {
          padding = 0,
          margin = { horizontal = 0 },
        },

        render = function(props)
          local function get_filename()
            local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
            if filename == "" then
              filename = "[No Name]"
            end
            local ft_icon, ft_color = devicons.get_icon_color(filename)
            local modified = vim.bo[props.buf].modified
            return {
              { filename, gui = modified and "bold,italic" or "bold" },
              " ",
              ft_icon and { ft_icon, " ", guibg = "none", guifg = ft_color } or "",
            }
          end

          return {
            { get_filename() },
            group = props.focused and "ColorColumn" or "SignColumn",
          }
        end,
      }
    end,
  },
}
