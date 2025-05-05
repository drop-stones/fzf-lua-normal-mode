---@class FzfLuaNormalModeOptions
---@field keys FzfLuaNormalModeKey[]

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

  return M.keys
end

return M
