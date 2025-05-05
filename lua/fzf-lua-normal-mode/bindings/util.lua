local M = {}

---Feed keys to enter insert mode and perform given action.
---@param action string
---@param exit? boolean
---@param move? string
function M.feed_insert(action, exit, move)
  local keys = "i" .. action .. (exit and ("<C-\\><C-N>" .. (move or "")) or "")
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "n", false)
end

---Exit insert mode with optional movement.
---@param move? string
function M.exit_insert(move)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-N>" .. (move or ""), true, false, true), "n", false)
end

---Wait until `mode` is confirmed, then call callback.
---@param mode string
---@param cb fun()
---@param interval_ms integer
---@param timeout_ms? integer
function M.wait_for_mode_switch(mode, cb, interval_ms, timeout_ms)
  local elapsed = 0
  local timer = vim.uv.new_timer()
  if not timer then
    return
  end

  local function check()
    if vim.api.nvim_get_mode().mode == mode or (timeout_ms and (elapsed > timeout_ms)) then
      pcall(function()
        timer:stop()
        timer:close()
      end)
      vim.schedule(cb)
    end
    elapsed = elapsed + interval_ms
  end

  timer:start(interval_ms, 0, vim.schedule_wrap(check))
end

return M
