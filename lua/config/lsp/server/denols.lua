local util = require("config.lsp.util")

local M = {}

local config_files = { "deno.json", "deno.jsonc" }

function M.setup(opts)
	opts.root_dir = util.get_root_pattern(config_files)

	require("lspconfig").denols.setup(opts)
end

return M
