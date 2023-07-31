# nvim

<div style="display: flex; gap: 1rem">
    <a href="https://dotfyle.com/snelling-a/nvim"><img src="https://dotfyle.com/snelling-a/nvim/badges/plugins?style=for-the-badge" /></a>
    <a href="https://dotfyle.com/snelling-a/nvim"><img src="https://dotfyle.com/snelling-a/nvim/badges/leaderkey?style=for-the-badge" /></a>
    <a href="https://dotfyle.com/snelling-a/nvim"><img src="https://dotfyle.com/snelling-a/nvim/badges/plugin-manager?style=for-the-badge" /></a>
</div>

## Install Instructions

> Install requires Neovim 0.9+. Always review the code before installing a configuration.

Clone the repository and install the plugins:

```sh
git clone git@github.com:snelling-a/nvim ~/.config/snelling-a/nvim
NVIM_APPNAME=snelling-a/nvim/ nvim --headless +"Lazy! sync" +qa
```

Open Neovim with this config:

```sh
NVIM_APPNAME=snelling-a/nvim/ nvim
```
