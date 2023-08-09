local M = {}

M.mason_name = "cbfmt"

local command = require("config.lsp.util").get_linter_formatter_command(M.mason_name, {
	"--stdin-filepath",
	"${INPUT}",
	"--best-effort",
})

function M.setup()
	return {
		formatCommand = command,
		formatStdin = true,
		rootMarkers = { ".cbfmt.toml" },
	}
end

return M
