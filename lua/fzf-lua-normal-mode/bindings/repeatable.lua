local util = require("fzf-lua-normal-mode.bindings.util")

local insert_lock = false

---Insert action and return to normal mode with lock control.
---@param action string
---@param interval_ms integer
local function repeatable_action(action, interval_ms)
  return function()
    if insert_lock == true then
      return
    end

    insert_lock = true

    -- Enter insert mode, send action, exit to normal mode and move right
    util.feed_insert(action, true, "l")

    -- Wait until we confirm we are back in normal mode
    util.wait_for_mode_switch("nt", function()
      insert_lock = false
    end, interval_ms)
  end
end

---Prevent key propagation in insert mode when insert lock is active.
---@param key string
local function insert_guard(key)
  return function()
    if insert_lock then
      return ""
    else
      return key
    end
  end
end

---Bind a repeatable key in normal and insert mode with guard.
---@param key string
---@param action string
---@param interval_ms integer
local function repeatable(key, action, interval_ms)
  vim.keymap.set("n", key, repeatable_action(action, interval_ms), { buffer = true })
  vim.keymap.set("i", key, insert_guard(key), { buffer = true })
end

return repeatable
