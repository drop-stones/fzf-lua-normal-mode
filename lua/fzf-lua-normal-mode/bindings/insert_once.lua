local util = require("fzf-lua-normal-mode.bindings.util")

---Bind an insert_once key in normal mode.
---@param key string
---@param action string
local function insert_once(key, action)
  vim.keymap.set("n", key, function()
    util.feed_insert(action)
  end, { buffer = true })
end

return insert_once
