local M = {}

M.mason_name = "prettier"

--- @param parser "html"|"json"
function M.setup(parser)
	local args = {
		"--stdin-filepath",
		"${INPUT}",
		"${--config-precedence:configPrecedence}",
		"--parser" .. (parser or "json"),
	}

	return {
		formatCommand = require("config.lsp.util").get_linter_formatter_command(M.mason_name, args),
		formatStdin = true,
	}
end

return M
