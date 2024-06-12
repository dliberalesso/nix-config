-- Loading shada is SLOW
-- Let's load it after UI-enter so it doesn't block startup.
---@class utils.shada
local M = {}

M.shada = ""
M.did_init = false

function M.init(shada)
  if M.did_init then
    return
  end

  M.did_init = true

  M.shada = shada
  vim.o.shada = ""
end

function M.setup()
  vim.o.shada = M.shada
  pcall(vim.cmd.rshada, { bang = true })
end

return M
