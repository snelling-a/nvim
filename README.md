# nvim

Personal Neovim configuration using native `vim.pack` for plugin management.

## Requirements

- Neovim 0.12+
- [ripgrep](https://github.com/BurntSushi/ripgrep)
- [fd](https://github.com/sharkdp/fd)
- A [Nerd Font](https://www.nerdfonts.com/)

## Install

> [!WARNING]
> Always review the code before installing a configuration.

```sh
git clone git@github.com:snelling-a/nvim ~/.config/nvim
nvim
```

To try it without affecting your existing config:

```sh
git clone git@github.com:snelling-a/nvim ~/.config/snelling-a/nvim
NVIM_APPNAME=snelling-a/nvim nvim
```

Plugins are installed automatically on first launch. Mason will install LSP servers, formatters, and linters.
