local Awk = {}

Awk.mason_name = "awk-language-server"

function Awk.setup(opts) require("lspconfig").awk_ls.setup(opts) end

return Awk
