---@type integer
local namespace = vim.api.nvim_create_namespace("fzf-lua-normal-mode")

---Perform insert action and wait for one user keystroke before exiting.
---@param action string
---@param defer_ms integer
---@return fun()
local function wait_user_input_action(action, defer_ms)
  return function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("i" .. action, true, false, true), "m", false)

    vim.defer_fn(function()
      vim.on_key(function(_, typed)
        if typed == nil or typed:len() ~= 1 then
          return
        end
        vim.on_key(nil, namespace) -- remove listener
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>l", true, false, true), "m", false)
      end, namespace)
    end, defer_ms)
  end
end

---Bind a key that requires one extra user input after insert.
---@param key string
---@param action string
---@param defer_ms integer
local function wait_user_input(key, action, defer_ms)
  vim.keymap.set("n", key, wait_user_input_action(action, defer_ms), { buffer = true })
end

return wait_user_input
