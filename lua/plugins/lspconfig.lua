---@type LazySpec
return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "williamboman/mason.nvim", cmd = { "Mason" }, build = ":MasonUpdate" },
		{ "b0o/SchemaStore.nvim", lazy = true },
		"j-hui/fidget.nvim",
		"williamboman/mason-lspconfig.nvim",
	},
	event = { "LazyFile" },
	config = function()
		Config.lsp.on_attach(Config.lsp.keymap.on_attach)
		Config.lsp.setup()
		Config.lsp.on_dynamic_capability(Config.lsp.keymap.on_attach)
		Config.lsp.words.setup()
		Config.lsp.diagnostics.on_attach()

		Config.lsp.on_supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, function(_, bufnr)
			if vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buftype == "" then
				vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
			end
		end)

		vim.lsp.handlers[vim.lsp.protocol.Methods.workspace_diagnostic_refresh] = function(_, _, ctx)
			local ns = vim.lsp.diagnostic.get_namespace(ctx.client_id)
			local bufnr = vim.api.nvim_get_current_buf()
			vim.diagnostic.reset(ns, bufnr)
			return true
		end

		local has_blink, blink = pcall(require, "blink.cmp")
		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			has_blink and blink.get_lsp_capabilities() or {},
			{
				workspace = {
					fileOperations = { didRename = true, willRename = true },
				},
			}
		)

		require("mason").setup()
		local have_mason, mlsp = pcall(require, "mason-lspconfig")

		---@param server_name string
		local function setup(server_name)
			local config = Config.lsp.servers[server_name]
			config.capabilities = has_blink and blink.get_lsp_capabilities(config.capabilities) or {}

			local server_opts = vim.tbl_deep_extend("force", {
				capabilities = vim.deepcopy(capabilities),
			}, Config.lsp.servers[server_name] or {})

			require("lspconfig")[server_name].setup(server_opts)
		end

		if have_mason then
			---@diagnostic disable-next-line: missing-fields
			mlsp.setup({
				ensure_installed = vim.tbl_keys(Config.lsp.servers),
				handlers = { setup },
			})
		end

		Config.lsp.handle_typescript_clients()
		Config.lsp.mason.check_install()
	end,
}
