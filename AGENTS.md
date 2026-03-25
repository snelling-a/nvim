# AGENTS.md

This file provides guidelines for agents working on this Neovim configuration repository.

## Testing

Agents cannot run Neovim interactively. Use these headless commands to validate changes:

```bash
# Check for Lua syntax errors
nvim --headless -c "luafile init.lua" -c "qa!" 2>&1

# Validate a specific Lua file parses correctly
nvim --headless -c "luafile lua/keymaps.lua" -c "qa!" 2>&1

# Run stylua check (dry-run, no changes)
nvim --headless -c "terminal stylua --check ." -c "qa!" 2>&1

# Run luacheck
nvim --headless -c "terminal luacheck ." -c "qa!" 2>&1
```

stylua and luacheck are only available inside an instance of neovim (installed via Mason).

## Architecture

This is a Neovim configuration (0.11+) using native `vim.pack` for plugin management.

### Directory Structure

- `init.lua` - Entry point (enables vim.loader, loads core modules)
- `plugin/` - Auto-loaded configuration:
  - `bool.lua` - Boolean toggling
  - `diagnostic.lua` - Diagnostic configuration
  - `easy-motion.lua` - Easy motion navigation
  - `gx.lua` - URL opener
  - `lsp.lua` - LSP setup and keymaps
  - `marks.lua` - Mark management
  - `overrides.lua` - Runtime overrides
  - `quickfix.lua` - Quickfix formatting
  - `string-weaver.lua` - String manipulation
  - `tabline.lua` - Custom tabline
  - `terminal.lua` - Terminal keymaps and autocmds
- `lsp/` - LSP server configs (auto-discovered, export `vim.lsp.Config`)
- `lua/` - Core modules (loaded by init.lua):
  - `options.lua` - Editor options
  - `keymaps.lua` - Key mappings
  - `autocmds.lua` - Autocommands
  - `commands.lua` - User commands
- `lua/` - Standalone modules:
  - `bool.lua` - Boolean value toggling
  - `bufdelete.lua` - Buffer deletion
  - `gitlink.lua` - Git permalink generation
  - `lsp_words.lua` - LSP document highlighting
  - `notify.lua` - Notification system
  - `string-weaver.lua` - String interpolation
  - `terminal.lua` - Terminal management
- `lua/plugins/` - Plugin configurations:
  - `init.lua` - Plugin declarations and auto-loading
  - `conform.lua` - Formatters
  - `lint.lua` - Linters
  - `mason.lua` - Mason package manager (auto-installs LSP servers, formatters, linters)
  - Other plugin-specific configs
- `after/ftplugin/` - Filetype settings

### Plugin Management

```lua
vim.pack.add({ "https://github.com/author/plugin" })

-- Lazy loading:
vim.pack.add({ "https://github.com/author/plugin" }, {
  load = function()
    vim.cmd.packadd("plugin")
    require("plugin").setup({})
  end,
})
```

### LSP Configuration

Files in `lsp/` are auto-discovered by `plugin/lsp.lua`. Each exports:

```lua
---@type vim.lsp.Config
return {
  cmd = { "server-binary" },
  filetypes = { "filetype" },
  root_markers = { ".git" },
  settings = {},
}
```

### Adding Language Support

Use the `/add-language` skill.

### Adding a Plugin

Use the `/add-plugin` skill.

## Code Style

- Format: stylua (sorted requires)
- snake_case for variables/functions
- Prefix private functions with `_`
- Use `pcall` for protected calls, `vim.notify` for errors
- Avoid hardcoded paths; use `vim.fn.stdpath`

