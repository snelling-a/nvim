local Bash = {}

Bash.mason_name = "bash-language-server"

function Bash.setup(opts) require("lspconfig").bashls.setup(opts) end

return Bash
