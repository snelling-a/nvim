---@type LazySpec
local M = { "neovim/nvim-lspconfig" }

M.opts = {
	servers = {
		eslint = {
			settings = {
				codeAction = {
					disableRuleComment = { enable = false },
					showDocumentation = { enable = true },
				},
				format = false,
				workingDirectories = { mode = "auto" },
			},
		},
	},
}

return M
