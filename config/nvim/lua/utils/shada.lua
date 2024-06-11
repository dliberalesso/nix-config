-- Loading shada is SLOW
-- Let's load it after UI-enter so it doesn't block startup.
---@class utils.shada
local M = {}

M.shada = ""

function M.init(shada)
  M.shada = shada
  vim.o.shada = ""
end

function M.setup()
  vim.o.shada = M.shada
  pcall(vim.cmd.rshada, { bang = true })
end

return M
