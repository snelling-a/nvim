local M = {}

M.mason_name = "shfmt"

local command = require("config.lsp.util").get_linter_formatter_command(M.mason_name, {
	"-filename",
	"${INPUT}",
	"-",
})

function M.setup()
	return {
		formatCommand = command,
		formatStdin = true,
	}
end

return M
