---@type LazySpec
local M = { "neovim/nvim-lspconfig" }

M.opts = {
	servers = {
		taplo = {
			settings = {
				evenBetterToml = {
					schema = {
						repositoryEnabled = true,
						enabled = true,
					},
				},
			},
		},
	},
}

return M
