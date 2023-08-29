local args = {
	"--stdin-filepath",
	"${INPUT}",
	"--best-effort",
}

local M = {}

M.mason_name = "cbfmt"

function M.setup()
	return {
		formatCommand = require("config.lsp.util").get_linter_formatter_command(M.mason_name, args),
		formatStdin = true,
		rootMarkers = {
			".cbfmt.toml",
		},
	}
end

return M
