---@type LazySpec
return {
	"nvim-mini/mini.indentscope",
	event = { "LazyFile" },
	init = function()
		vim.api.nvim_create_autocmd({ "FileType" }, {
			callback = function(args)
				vim.b[args.buf].miniindentscope_disable = true
			end,
			desc = "Disable MiniIndentscope for certain filetypes",
			group = require("user.autocmd").augroup("MiniIndentscope"),
			pattern = vim.g.disabled_filetypes,
		})
	end,
	opts = {
		symbol = require("icons").fillchars.vert,
		options = { try_as_border = true },
	},
}
