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

--- Prefer a hoisted toolchain: workspace root may be packages/foo while oxlint lives
--- at repo root node_modules/.bin (pnpm / npm workspaces).
---@param root_dir string?
---@return string
local function _resolve_oxlint_cmd(root_dir)
	local name = "oxlint"
	if root_dir then
		local dir = root_dir
		for _ = 1, 64 do
			local candidate = vim.fs.joinpath(dir, "node_modules", ".bin", name)
			if vim.fn.executable(candidate) == 1 then
				return candidate
			end
			local parent = vim.fn.fnamemodify(dir, ":h")
			if parent == dir then
				break
			end
			dir = parent
		end
	end

	local mason_cmd = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "bin", name)
	if vim.fn.executable(mason_cmd) == 1 then
		return mason_cmd
	end

	return name
end

---@type vim.lsp.Config
return {
	cmd = function(dispatchers, config)
		local cmd = _resolve_oxlint_cmd((config or {}).root_dir)
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
	-- Oxlint config markers first; then package.json for JS/TS trees without a local oxlintrc.
	root_markers = {
		".oxlintrc.json",
		".oxlintrc.jsonc",
		"oxlint.config.ts",
		"package.json",
	},
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
