# AGENTS.md

This file provides guidelines for agents working on this Neovim configuration repository. Follow these instructions to ensure consistency and maintainability.

## Build and Lint Commands

### Build
- **Install dependencies:**
  Use `vim.pack.add()` in Lua files to add plugins. For example:
  ```lua
  vim.pack.add({ "https://github.com/ibhagwan/fzf-lua" }, {
    load = function()
      vim.cmd.packadd("fzf-lua")
      require("fzf-lua").setup({})
    end,
  })
  ```
  Plugins are automatically loaded from the `pack/` directory.

### Lint
- **Check Lua code style:**
  ```bash
  stylua .
  ```
  Ensure `stylua` is installed for formatting Lua files.

## Code Style Guidelines

### General
- Use Lua for configuration files.
- Keep functions modular and reusable.
- Avoid hardcoding paths; use `vim.fn.stdpath` where possible.

### Imports
- Group imports logically (e.g., plugins, settings, keymaps).
- Use `require` statements for modular files.

### Formatting
- Use `stylua` for consistent formatting.
- Indentation: 2 spaces.
- Line length: 80 characters.

### Naming Conventions
- Use snake_case for variables and functions.
- Prefix private functions with `_`.
- Use descriptive names for key mappings and settings.

### Error Handling
- Use `pcall` for protected calls to avoid breaking the editor.
- Log errors using `vim.notify` for better visibility.

## Adding Language Support

To add support for a new language, follow these steps:

1. **Set up the LSP:**
   - Create a new file in `after/lsp/` for the language server configuration.
   - Define the `cmd`, `filetypes`, `root_markers`, and `settings` as needed.

2. **Add formatters:**
   - Update `plugin/92_conform.lua` to include formatters for the new language.
   - Add the language to the `formatters_by_ft` table with appropriate formatters.

3. **Add linters:**
   - Update `plugin/93_lint.lua` to include linters for the new language.
   - Add the language to the `linters_by_ft` table with appropriate linters.

4. **Test the setup:**
   - Open a file of the new language type and ensure the LSP, formatters, and linters work correctly.

## Additional Notes
- Document all key mappings and plugin configurations.
- Test changes in a clean Neovim environment to ensure compatibility.
- Follow best practices for Neovim Lua development.

By adhering to these guidelines, you ensure that this configuration remains clean, maintainable, and user-friendly.