# AGENTS.md

This file provides guidelines for agents working on this Neovim configuration repository.

## Running Neovim

This config uses a git worktree. To run it headlessly:

```bash
NVIM_APPNAME=nvim/.worktrees/rewrite nvim
```

## Commands

stylua and luacheck are only available inside an instance of neovim:

```vim
:terminal stylua .
:terminal luacheck .
```

## Architecture

This is a Neovim configuration (0.11+) using native `vim.pack` for plugin management.

### Directory Structure

- `init.lua` - Entry point (enables vim.loader)
- `plugin/` - Auto-loaded configuration:
  - `diagnostic.lua` - Diagnostic configuration
  - `netrw.lua` - Netrw settings
  - `overrides.lua` - Runtime overrides
- `lsp/` - LSP server configs (auto-discovered, export `vim.lsp.Config`)
- `lua/config/` - Core configuration (loaded via `require("config")`):
  - `init.lua` - Entry point, loads other config modules
  - `options.lua` - Editor options
  - `keymaps.lua` - Key mappings
  - `autocmds.lua` - Autocommands
  - `commands.lua` - User commands
  - `lsp.lua` - LSP setup
- `lua/plugins/` - Plugin configurations:
  - `init.lua` - Plugin declarations
  - `conform.lua` - Formatters
  - `lint.lua` - Linters
  - Other plugin-specific configs
- `lua/` - Standalone modules (bufdelete, netrw_git, netrw_icons)
- `after/ftplugin/` - Filetype settings
- `after/syntax/` - Syntax overrides

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

Files in `lsp/` are auto-discovered. Each exports:

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

1. Create `lsp/<server>.lua`
2. Add formatters to `formatters_by_ft` in `lua/plugins/conform.lua`
3. Add linters to `linters_by_ft` in `lua/plugins/lint.lua`

## Code Style

- Format: stylua (2-space indent, 80 char lines, sorted requires)
- snake_case for variables/functions
- Prefix private functions with `_`
- Use `pcall` for protected calls, `vim.notify` for errors
- Avoid hardcoded paths; use `vim.fn.stdpath`

