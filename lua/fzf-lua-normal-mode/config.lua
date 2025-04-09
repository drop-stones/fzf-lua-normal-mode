---@class FzfLuaNormalModeOptions
---@field keys FzfLuaNormalModeKey[]
---@field defer_ms integer

local M = {}

---@type FzfLuaNormalModeKey
local default_key = {
  key = "",
  action = "",
  repeatable = true,
  wait_user_input = false,
}

---@type FzfLuaNormalModeKey[]
M.keys = {}

---@type integer
M.defer_ms = 20

---Merge user keymap options with defaults and return configuration.
---@param user_options FzfLuaNormalModeOptions
function M.setup(user_options)
  M.keys = vim.tbl_map(function(keybind)
    local _keybind = vim.tbl_deep_extend("force", default_key, keybind)
    if type(_keybind.action) == "function" then
      _keybind.repeatable = false
      _keybind.wait_user_input = false
    elseif _keybind.wait_user_input then
      _keybind.repeatable = false
    end
    return _keybind
  end, user_options.keys or {})

  M.defer_ms = user_options.defer_ms or M.defer_ms

  return M.keys, M.defer_ms
end

return M
