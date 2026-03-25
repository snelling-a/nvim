---
name: add-plugin
description: Use when adding a new plugin to the Neovim config - declares with vim.pack.add, creates config file, handles lazy loading
---

# Add Plugin

Adds a plugin to the Neovim configuration at `config/nvim/.worktrees/rewrite/`.

## Steps

1. **Decide loading strategy:**
   - **Eager** (loads on startup): most plugins
   - **Lazy** (loads on demand): plugins for specific filetypes or commands

2. **Add plugin declaration and config** in `lua/plugins/<name>.lua`:

### Eager (with config)

```lua
vim.pack.add({ { src = "https://github.com/author/plugin.nvim" } })

require("plugin").setup({
  -- options
})
```

### Lazy (load on demand)

```lua
vim.pack.add({ { src = "https://github.com/author/plugin.nvim" } }, {
  load = function()
    vim.cmd.packadd("plugin.nvim")
    require("plugin").setup({
      -- options
    })
  end,
})
```

### Lazy (filetype trigger)

```lua
vim.pack.add({ "https://github.com/author/plugin.nvim" }, { load = false })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "filetype",
  once = true,
  callback = function()
    vim.cmd.packadd("plugin.nvim")
    require("plugin").setup({})
  end,
})
```

### No config needed

Add to the list in `lua/plugins/init.lua`:

```lua
vim.pack.add({
  { src = "https://github.com/author/plugin.nvim" },
  -- other no-config plugins...
}, { load = false })
```

1. **Add keymaps** in the plugin config file or in `lua/keymaps.lua` if they're global.

## Quick Reference

| What              | Where                                |
| ----------------- | ------------------------------------ |
| Plugin config     | `lua/plugins/<name>.lua`             |
| No-config plugins | `lua/plugins/init.lua`               |
| Lock file         | `nvim-pack-lock.json` (auto-managed) |
