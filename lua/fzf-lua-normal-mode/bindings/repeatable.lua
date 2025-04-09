local insert_lock = false

---Insert action and return to normal mode with lock control.
---@param action string
---@param defer_ms integer
local function repeatable_action(action, defer_ms)
  return function()
    if insert_lock == true then
      return
    end

    insert_lock = true

    local feedkeys = vim.api.nvim_replace_termcodes("i" .. action .. "<C-\\><C-N>" .. "l", true, false, true)
    vim.api.nvim_feedkeys(feedkeys, "m", false)

    -- defer `defer_ms` ms to switch to normal mode
    vim.defer_fn(function()
      insert_lock = false
    end, defer_ms)
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
---@param defer_ms integer
local function repeatable(key, action, defer_ms)
  vim.keymap.set("n", key, repeatable_action(action, defer_ms), { buffer = true })
  vim.keymap.set("i", key, insert_guard(key), { buffer = true })
end

return repeatable
