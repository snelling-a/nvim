-- Based on https://github.com/neovim/nvim-lspconfig/blob/master/lsp/oxlint.lua

---@param root_dir string
---@return boolean
local function _oxlint_conf_mentions_typescript(root_dir)
	for _, name in ipairs({ ".oxlintrc.json", ".oxlintrc.jsonc" }) do
		local path = vim.fs.joinpath(root_dir, name)
		local f = io.open(path, "r")
		if f then
			local body = f:read("*a") or ""
			f:close()
			if body:find("typescript") then
				return true
			end
		end
	end
	return false
end

---@type vim.lsp.Config
return {
	cmd = function(dispatchers, config)
		local cmd = "oxlint"
		if (config or {}).root_dir then
			local local_cmd = vim.fs.joinpath(config.root_dir, "node_modules/.bin", cmd)
			if vim.fn.executable(local_cmd) == 1 then
				cmd = local_cmd
			end
		end
		return vim.lsp.rpc.start({ cmd, "--lsp" }, dispatchers)
	end,
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"vue",
		"svelte",
		"astro",
	},
	root_markers = { ".oxlintrc.json", ".oxlintrc.jsonc", "oxlint.config.ts" },
	workspace_required = true,
	on_attach = function(client, bufnr)
		vim.api.nvim_buf_create_user_command(bufnr, "LspOxlintFixAll", function()
			client:exec_cmd({
				title = "Apply Oxlint automatic fixes",
				command = "oxc.fixAll",
				arguments = { { uri = vim.uri_from_bufnr(bufnr) } },
			})
		end, {
			desc = "Apply Oxlint automatic fixes",
		})
	end,
	settings = {},
	before_init = function(init_params, config)
		local settings = config.settings or {}
		if settings.typeAware == nil and vim.fn.executable("tsgolint") == 1 then
			local ok, res = pcall(_oxlint_conf_mentions_typescript, config.root_dir)
			if ok and res then
				settings = vim.tbl_extend("force", settings, { typeAware = true })
			end
		end
		local init_options = config.init_options or {}
		init_options.settings = vim.tbl_extend("force", init_options.settings or {} --[[@as table]], settings)

		init_params.initializationOptions = init_options
	end,
}
