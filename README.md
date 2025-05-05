# fzf-lua-normal-mode

This plugin allows you to define custom normal mode keybindings that interact with `fzf-lua` prompts in a clean and intuitive way—without needing to drop into insert mode or write complicated mappings.

## ⚡️ Requirements

- Neovim >= **0.10.0**
- [`fzf-lua`](https://github.com/ibhagwan/fzf-lua)

## ✨ Features

- Use familiar normal mode keys inside `fzf-lua` windows
- Supports:
  - **Repeatable keys** (e.g., `j`, `k`, `<C-d>`) for navigation
  - **Exit keys** (e.g., `q`, `<CR>`) to close or confirm
  - Keys that **wait for additional user input** (e.g., jumps in `fzf-lua`)

## 📦 Installation

Install the plugin with your preferred package manager.

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "ibhagwan/fzf-lua",
  dependencies = { "drop-stones/fzf-lua-normal-mode" },
},
{
  "drop-stones/fzf-lua-normal-mode",
  opts = {
    -- see configuration section
  }
}
```

## 🚀 How it works

When a `fzf-lua` prompt opens:

- Your configured normal mode keybindings are bound **buffer-locally**
- Keys act depending on their type:

| Key Type          | Behavior                                                                 |
|-------------------|--------------------------------------------------------------------------|
| `repeatable = true` (default) | Enters insert mode, sends `action`, exits back to normal mode after a delay |
| `repeatable = false`         | Sends insert-mode `action` and stays in normal mode          |
| `wait_user_input = true`     | Sends `action`, waits for one more user key, then exits insert mode |

> [!WARNING]
>
> - If `action` is a function, both `repeatable` and `wait_user_input` are ignored. You take full control.
> - If both `repeatable` and `wait_user_input` are `true`, `repeatable` is ignored.
>

## ⚙️  Configuration

You can configure the plugin via the following options.

> [!important]
> 🩺 Run `:checkhealth fzf-lua-normal-mode` if you run into any issues.

### 🔑 `keys`

An array of keybind definitions. Each item is a table with:

| Field | Type | Description |
| ----- | ---- | ----------- |
| `key` | `string` | Normal mode key to bind (e.g., `j`, `q`, `s`) |
| `action` | `string` or `function` | What to execute; string is treated as insert-mode input |
| `repeatable` | `boolean` (optional) | Default: `true`. Enables repeatable behavior like movement keys |
| `wait_user_input` | `boolean` (optional) | Default: `false`. Waits for one more character after executing `action` |

### Example

```lua
{
  keys = {
    -- repeatable keys
    { key = "j", action = "<Down>" },
    { key = "k", action = "<Up>" },
    { key = "gg", action = "<A-g>" },
    { key = "G", action = "<A-G>" },
    { key = "<C-u>", action = "<C-u>" },
    { key = "<C-d>", action = "<C-d>" },
    -- additional user input keys
    { key = "s", action = "<your-jumps-keybind>", wait_user_input = true },
    -- exit keys
    { key = "q", action = "<Esc>", repeatable = false },
    { key = "<Enter>", action = "<CR>", repeatable = false },
    -- custom function keys
    { key = "z", action = function() vim.cmd("echo 'custom action'") end },
  }
}
```

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
