local args = {
	"-filename",
	"${INPUT}",
	"-",
}

local M = {}

M.mason_name = "shfmt"

function M.setup()
	return {
		formatCommand = require("config.lsp.util").get_linter_formatter_command(M.mason_name, args),
		formatStdin = true,
	}
end

return M
