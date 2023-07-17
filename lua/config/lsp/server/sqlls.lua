local Sql = {}

function Sql.setup(opts) require("lspconfig").sqlls.setup(opts) end

return Sql
