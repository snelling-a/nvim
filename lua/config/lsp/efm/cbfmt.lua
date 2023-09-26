local args = {
    "--best-effort",
	"--stdin-filepath",
	"${INPUT}",
}

local M = {}

M.mason_name = "cbfmt"

M.config = {
	formatCommand = require("config.lsp.util").get_linter_formatter_command(M.mason_name, args),
	formatStdin = true,
}

return M
