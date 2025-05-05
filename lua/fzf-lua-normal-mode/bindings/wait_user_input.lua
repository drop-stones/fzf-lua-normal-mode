local util = require("fzf-lua-normal-mode.bindings.util")

---@type integer
local namespace = vim.api.nvim_create_namespace("fzf-lua-normal-mode")

---Perform insert action and wait for one user keystroke before exiting.
---@param action string
---@param interval_ms integer
---@return fun()
local function wait_user_input_action(action, interval_ms)
  return function()
    util.feed_insert(action)
    util.wait_for_mode_switch("t", function()
      vim.on_key(function(_, key)
        if key and #key == 1 then
          vim.on_key(nil, namespace) -- remove listener
          util.exit_insert("l")
        end
      end, namespace)
    end, interval_ms)
  end
end

---Bind a key that requires one extra user input after insert.
---@param key string
---@param action string
---@param interval_ms integer
local function wait_user_input(key, action, interval_ms)
  vim.keymap.set("n", key, wait_user_input_action(action, interval_ms), { buffer = true })
end

return wait_user_input
