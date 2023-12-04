local Lsp = require("lsp")

return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				eslint = {
					settings = {
						workingDirectories = { mode = "auto" },
					},
				},
			},
			setup = {
				eslint = function()
					local formatter = require("lsp").format.formatter({
						name = "eslint: lsp",
						primary = false,
						priority = 200,
						filter = "eslint",
					})

					if not pcall(require, "vim.lsp._dynamic") then
						local function get_client(buf)
							return Lsp.util.get_clients({ name = "eslint", bufnr = buf })[1]
						end

						formatter.name = "eslint: EslintFixAll"
						formatter.sources = function(buf)
							local client = get_client(buf)
							return client and { "eslint" } or {}
						end
						formatter.format = function(buf)
							local client = get_client(buf)
							if client then
								local diag = vim.diagnostic.get(buf, {
									namespace = vim.lsp.diagnostic.get_namespace(client.id),
								})
								if #diag > 0 then
									vim.cmd.EslintFixAll()
								end
							end
						end
					end

					Lsp.format.register(formatter)
				end,
			},
		},
	},
}
