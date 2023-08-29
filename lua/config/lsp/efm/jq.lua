local args = {
	".",
}

local M = {}

M.mason_name = "jq"

local command = require("config.lsp.util").get_linter_formatter_command(M.mason_name, args)

function M.setup()
	return {
		prefix = M.mason_name,
		lintCommand = command,
		lintStdin = true,
		formatCommand = command,
		formatStdin = true,
		rootMarkers = {},
	}
end

return M
