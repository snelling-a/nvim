local Base16 = { "snelling-a/base16.nvim" }

Base16.dev = true

Base16.lazy = false

Base16.priority = 1000

function Base16.config() vim.cmd.colorscheme("base16-default-dark") end

return Base16
