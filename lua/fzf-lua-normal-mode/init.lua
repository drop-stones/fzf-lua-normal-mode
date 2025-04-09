local config = require("fzf-lua-normal-mode.config")

local M = {}

---Sets up the plugin with user-provided options.
---@param user_options? FzfLuaNormalModeOptions
function M.setup(user_options)
  local _keys, _defer_ms = config.setup(user_options or {})
end

return M
