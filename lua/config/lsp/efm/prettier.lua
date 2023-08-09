local M = {}

M.mason_name = "prettier"

---@param parser "json"|"css"
function M.setup(parser)
	local args = {
		"--stdin-filepath",
		"${INPUT}",
		"${--config-precedence:configPrecedence}",
		"--parser" .. (parser or "json"),
	}

	local command = require("config.lsp.util").get_linter_formatter_command(M.mason_name, args)

	return {
		formatCommand = command,
		formatStdin = true,
	}
end

return M
