local config_files = { "deno.json", "deno.jsonc" }

local M = {}

M.mason_name = "deno"

function M.setup(opts)
	opts.root_dir = require("config.lsp.util").get_root_pattern(config_files)

	require("lspconfig").denols.setup(opts)
end

return M
