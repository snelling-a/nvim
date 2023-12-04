---@type LazySpec
local M = { "neovim/nvim-lspconfig" }

M.opts = {
	servers = {
		marksman = {},
	},
}

local language_setup = require("lsp.util").setup_language({
	ts = { "markdown", "markdown_inline" },
	linters = { "prettierd", "markdownlint" },
	formatters = { "prettierd" },
})

return {
	M,
	unpack(language_setup),
}
