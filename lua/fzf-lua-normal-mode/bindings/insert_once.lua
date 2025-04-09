---Perform action and exit insert mode without locking.
---@param action string
local function insert_once_action(action)
  return function()
    local feedkeys = vim.api.nvim_replace_termcodes("i" .. action, true, false, true)
    vim.api.nvim_feedkeys(feedkeys, "n", false)
  end
end

---Bind an insert_once key in normal mode.
---@param key string
---@param action string
local function insert_once(key, action)
  vim.keymap.set("n", key, insert_once_action(action), { buffer = true })
end

return insert_once
