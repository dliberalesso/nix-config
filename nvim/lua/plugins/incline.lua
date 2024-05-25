return {
  {
    "b0o/incline.nvim",

    dependencies = {
      "rachartier/tiny-devicons-auto-colors.nvim",
      "echasnovski/mini.diff",
    },

    event = "VeryLazy",

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
              " ",
              { filename, gui = modified and "bold,italic" or "bold" },
              " ",
              ft_icon and { ft_icon, " ", guibg = "none", guifg = ft_color } or "",
            }
          end

          local function get_diagnostics()
            local icons = {
              error = " ",
              warn = " ",
              info = " ",
              hint = " ",
            }
            local labels = {}

            for severity, icon in pairs(icons) do
              local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
              if n > 0 then
                table.insert(labels, { " " .. icon .. n, group = "DiagnosticSign" .. severity })
              end
            end
            if #labels > 0 then
              table.insert(labels, { " ┊" })
            end
            return labels
          end

          local function get_mini_diff()
            local icons = {
              add = " ",
              change = " ",
              delete = " ",
            }
            local signs = vim.b[props.buf].minidiff_summary

            local labels = {}
            if signs == nil then
              return labels
            end
            for name, icon in pairs(icons) do
              if tonumber(signs[name]) and signs[name] > 0 then
                table.insert(labels, { " ", icon .. signs[name], group = "MiniDiffSign" .. name })
              end
            end
            if #labels > 0 then
              table.insert(labels, { " 󰊢 " .. signs.n_ranges .. " ┊" })
            end
            return labels
          end

          -- local function get_grapple_status()
          --   local grapple_status
          --   grapple_status = require("grapple").name_or_index({ buffer = props.buf }) or ""
          --   if grapple_status ~= "" then
          --     grapple_status = { { " 󰛢 ", group = "Function" }, { grapple_status, group = "Constant" } }
          --   end
          --   return grapple_status
          -- end

          return {
            { get_diagnostics() },
            { get_mini_diff() },
            -- { get_grapple_status() },
            { get_filename() },
            group = props.focused and "ColorColumn" or "SignColumn",
          }
        end,
      }
    end,
  },
}
