---@type LazySpec
local M = { "neovim/nvim-lspconfig" }

M.opts = {
	servers = {
		dockerls = {},
		docker_compose_language_service = {},
	},
}

local languge_setup = require("lsp.util").setup_language({
	langs = { "dockerfile" },
	linters = { "hadolint" },
})

return {
	M,
	unpack(languge_setup),
}
