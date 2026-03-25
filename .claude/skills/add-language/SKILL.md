---
name: add-language
description: Use when adding language support to the Neovim config - creating LSP server configs, adding formatters and linters
---

# Add Language Support

Adds language support to the Neovim configuration at `config/nvim/.worktrees/rewrite/`.

## Steps

1. **Create LSP config** at `lsp/<server-name>.lua`:

Use https://github.com/neovim/nvim-lspconfig/tree/master/lsp as a starting point for the server config. Find the matching server file there and adapt it.

```lua
---@type vim.lsp.Config
return {
  cmd = { "server-binary" },
  filetypes = { "filetype" },
  root_markers = { ".git" },
  settings = {},
}
```

The file name must match the Mason package name. `plugin/lsp.lua` auto-discovers all files in `lsp/`.

1. **Add formatter** to `formatters_by_ft` in `lua/plugins/conform.lua`:

```lua
filetype = { "formatter-name" },
-- or with fallback:
filetype = { "prettierd", "prettier", stop_after_first = true },
```

1. **Add linter** to `linters_by_ft` in `lua/plugins/lint.lua`:

```lua
filetype = { "linter-name" },
```

1. **Add filetype settings** (optional) at `after/ftplugin/<filetype>.lua` for indent, textwidth, etc.

Mason auto-installs the LSP server, formatter, and linter on next startup.

## Looking Up Names

| What        | Where to find                                                                          |
| ----------- | -------------------------------------------------------------------------------------- |
| LSP servers | https://mason-registry.dev/registry/list — file name must match the Mason package name |
| Formatters  | https://github.com/stevearc/conform.nvim — see "Formatters" section in README          |
| Linters     | https://github.com/mfussenegger/nvim-lint — see "Available Linters" section in README  |

## Quick Reference

| What            | Where                                          |
| --------------- | ---------------------------------------------- |
| LSP config      | `lsp/<server>.lua`                             |
| Formatters      | `lua/plugins/conform.lua` → `formatters_by_ft` |
| Linters         | `lua/plugins/lint.lua` → `linters_by_ft`       |
| Filetype opts   | `after/ftplugin/<ft>.lua`                      |
| Mason skip list | `lua/plugins/mason.lua` → `skip` table         |
