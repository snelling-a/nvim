local M = {}

M.mason_name = "yamlfmt"

local command = require("config.lsp.util").get_linter_formatter_command(M.mason_name, {
	"-",
})

function M.setup()
	return {
		prefix = M.mason_name,
		lintCommand = command,
		lintStdin = true,
		rootMarkers = { ".yamlfmt" },
	}
end

return M
