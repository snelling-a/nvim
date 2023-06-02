local Feline = { "freddiehaddad/feline.nvim" }

Feline.cond = require("config.util").is_vim()

function Feline.config() require("feline").setup(require("config.ui.statusline")) end

return Feline
