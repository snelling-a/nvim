local LspInlayHints = { "lvimuser/lsp-inlayhints.nvim" }

LspInlayHints.ft = table.insert(require("config.util.constants").javascript_typescript, "lua")

LspInlayHints.branch = "anticonceal"

LspInlayHints.event = "LspAttach"

LspInlayHints.config = function(_, opts)
	require("lsp-inlayhints").setup(opts)

	vim.api.nvim_create_autocmd("LspAttach", {
		group = require("config.util").augroup("LspInlayHints"),
		callback = function(args)
			if not (args.data and args.data.client_id) then
				return
			end
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			require("lsp-inlayhints").on_attach(client, args.buf, true)
		end,
	})
end

return LspInlayHints
