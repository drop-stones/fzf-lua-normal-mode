local config = require("fzf-lua-normal-mode.config")
local keys = require("fzf-lua-normal-mode.keys")

local M = {}

---Sets up the plugin with user-provided options.
---@param user_options? FzfLuaNormalModeOptions
function M.setup(user_options)
  local _keys, _defer_ms = config.setup(user_options or {})
  keys.setup_keymap(_keys, _defer_ms)
end

return M
