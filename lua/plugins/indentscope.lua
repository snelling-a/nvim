---@type LazySpec
return {
	"echasnovski/mini.indentscope",
	event = { "LazyFile" },
	init = function()
		vim.api.nvim_create_autocmd({ "FileType" }, {
			pattern = vim.g.disabled_filetypes,
			callback = function()
				vim.b.miniindentscope_disable = true
			end,
			group = vim.api.nvim_create_augroup("MiniIndentscope", {}),
		})
	end,
	opts = {
		symbol = require("icons").fillchars.vert,
		options = { try_as_border = true },
	},
}
