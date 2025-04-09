local config = require("fzf-lua-normal-mode.config")

---@class NeovimVersion
---@field major integer
---@field minor integer
---@field patch integer

---Checks if the current Neovim version is greater or equal to the given version.
---@param required_version NeovimVersion
local function check_nvim_version(required_version)
  local version = vim.version()
  local nvim_version = string.format("%d.%d.%d", version.major, version.minor, version.patch)

  if
    version.major > required_version.major
    or (version.major == required_version.major and version.minor > required_version.minor)
    or (
      version.major == required_version.major
      and version.minor == required_version.minor
      and version.patch >= required_version.patch
    )
  then
    vim.health.ok("Neovim version: " .. nvim_version)
  else
    vim.health.warn("Neovim version is outdated: " .. nvim_version .. " (0.10+ recommended)")
  end
end

---Checks if a plugin is installed and reports its status.
---@param plugin_name string
---@param require_name string
---@param is_required boolean
local function check_plugin(plugin_name, require_name, is_required)
  local ok, _ = pcall(require, require_name)
  if ok then
    vim.health.ok(plugin_name .. " is installed")
  else
    if is_required then
      vim.health.error(plugin_name .. " is not installed (required)")
    else
      vim.health.warn(plugin_name .. " is not installed (optional)")
    end
  end
end

---Check fzf-lua-normal-mode configuration
local function check_options()
  local warn_missing_fields = false
  local warn_key_type = false
  local warn_action_type = false

  for _, keybind in ipairs(config.keys) do
    -- Accumulate type/missing warnings to avoid duplicate outputs
    if not keybind.key or not keybind.action then
      warn_missing_fields = true
    else
      if type(keybind.key) ~= "string" then
        warn_key_type = true
      end
      if type(keybind.action) ~= "string" and type(keybind.action) ~= "function" then
        warn_action_type = true
      end
    end
  end

  if warn_missing_fields then
    vim.health.warn("Each keybind must define both `key` and `action`.")
  end
  if warn_key_type then
    vim.health.warn("`key` must be a string.")
  end
  if warn_action_type then
    vim.health.warn("`action` must be a string or a function.")
  end

  -- Warn about out-of-range defer_ms values
  if 10 <= config.defer_ms and config.defer_ms <= 50 then
    vim.health.ok("`defer_ms` is " .. config.defer_ms .. ".")
  else
    vim.health.warn("`defer_ms` is " .. config.defer_ms .. ". Consider a value between 10 and 50 for stability.")
  end
end

return {
  check = function()
    vim.health.start("fzf-lua-normal-mode")

    check_nvim_version({ major = 0, minor = 10, patch = 0 })
    check_plugin("fzf-lua", "fzf-lua", true)

    check_options()
  end,
}
