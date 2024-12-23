---@type LazySpec
return {
	"JoosepAlviste/nvim-ts-context-commentstring",
	dependencies = {
		{
			"numToStr/Comment.nvim",
			keys = {
				{
					"gb",
					mode = { "n", "v" },
					desc = "To[g]gle [b]lock comment",
				},
			},
			---@type CommentConfig
			---@diagnostic disable-next-line: missing-fields
			opts = {
				---@diagnostic disable-next-line: missing-fields, assign-type-mismatch
				toggler = { line = nil },
				---@diagnostic disable-next-line: missing-fields
				opleader = { line = "nil" },
				---@diagnostic disable-next-line: missing-fields
				mappings = { extra = false },
			},
		},
	},
	config = function()
		require("ts_context_commentstring").setup({ enable_autocmd = false })

		local get_option = vim.filetype.get_option
		---@diagnostic disable-next-line: duplicate-set-field
		vim.filetype.get_option = function(filetype, option)
			return option == "commentstring" and require("ts_context_commentstring.internal").calculate_commentstring()
				or get_option(filetype, option)
		end
	end,
}
