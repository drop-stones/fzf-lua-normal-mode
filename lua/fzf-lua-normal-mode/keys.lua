local bindings = require("fzf-lua-normal-mode.bindings")

---@type integer
local interval_ms = 20

---@class FzfLuaNormalModeKey
---@field key string
---@field action string|fun()
---@field repeatable? boolean
---@field wait_user_input? boolean

local M = {}

---Register keymaps for fzf-lua buffer based on key type.
---@param keys FzfLuaNormalModeKey[]
function M.setup_keymap(keys)
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "fzf",
    callback = function()
      for _, keybind in ipairs(keys) do
        if type(keybind.action) == "function" then
          vim.keymap.set("n", keybind.key, keybind.action, { buffer = true })
        elseif keybind.wait_user_input == true then
          bindings.wait_user_input(keybind.key, keybind.action --[[@as string]], interval_ms)
        elseif keybind.repeatable == true then
          bindings.repeatable(keybind.key, keybind.action --[[@as string]], interval_ms)
        else
          bindings.insert_once(keybind.key, keybind.action --[[@as string]])
        end
      end
    end,
  })
end

return M
