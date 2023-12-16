local M = { "neovim/nvim-lspconfig" }

M.event = { "FileLoaded" }

M.dependencies = {
	{
		"folke/neodev.nvim",
		opts = {},
	},
	"williamboman/mason-lspconfig.nvim",
	"williamboman/mason.nvim",
}

local severity = vim.diagnostic.severity
local icons = require("ui").icons.diagnostics
---@class lsp.opts
M.opts = {
	capabilities = {},
	diagnostics = {
		float = {
			border = "rounded",
			header = "",
			prefix = "",
			source = "always",
			style = "minimal",
		},
		severity_sort = true,
		signs = {
			text = {
				[severity.ERROR] = icons.Error,
				[severity.HINT] = icons.Hint,
				[severity.INFO] = icons.Info,
				[severity.WARN] = icons.Warn,
			},
		},
		underline = true,
		update_in_insert = false,
		virtual_text = false,
	},
	format = { formatting_options = nil, timeout_ms = nil },
	inlay_hints = true,
	---@type lspconfig.Config[]
	servers = { bashls = {} },
	setup = {},
}

---@param opts lsp.Opts
function M.config(_, opts)
	require("lspconfig.ui.windows").default_options.border = "rounded"

	local Lsp = require("lsp"):init(opts)
	local Methods = vim.lsp.protocol.Methods
	local handlers = vim.lsp.handlers

	Lsp.format.register(Lsp.format.formatter())

	Lsp.on_attach(function(client, bufnr)
		Lsp.keymap.on_attach(client, bufnr)
		Lsp.rename.on_attach(client, bufnr)
	end)

	local register_capability = handlers[Methods.client_registerCapability]

	handlers[Methods.client_registerCapability] = function(err, res, ctx)
		local ret = register_capability(err, res, ctx)
		local client_id = ctx.client_id
		local client = vim.lsp.get_client_by_id(client_id) or {}
		local bufnr = vim.api.nvim_get_current_buf()
		require("lsp").keymap.on_attach(client, bufnr)
		return ret
	end

	handlers[Methods.textDocument_hover] = vim.lsp.with(handlers.hover, { border = "rounded" })
	handlers[Methods.textDocument_signatureHelp] = vim.lsp.with(handlers.signature_help, { border = "rounded" })

	local function inlay_hint_on_attach(client, bufnr)
		if client.supports_method(Methods.textDocument_inlayHint) then
			local inlay_hint = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint.enable

			inlay_hint(bufnr, true)
		end
	end

	Lsp.on_attach(inlay_hint_on_attach)

	local Mason = Lsp.mason
	Mason.get_ensure_installed(Lsp)
	Mason.install_ensured(Lsp)

	local enhanced_float_handler = Lsp.highlight.enhanced_float_handler

	handlers[Methods.textDocument_hover] = enhanced_float_handler(handlers.hover, true)
	handlers[Methods.textDocument_signatureHelp] = enhanced_float_handler(handlers.signature_help, false)

	Lsp.highlight.stylize_markdown()

	require("lsp.lightbulb")
	if Lsp.util.get_config("denols") and Lsp.util.get_config("tsserver") then
		local is_deno = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")
		Lsp.util.disable("tsserver", is_deno)
		Lsp.util.disable("denols", function(root_dir)
			return not is_deno(root_dir)
		end)
	end
end

return M
