---@type LazySpec
local M = { "echasnovski/mini.comment" }

M.keys = {
	{ "gcc", desc = "Comment line" },
	{ "gc", mode = { "x" }, desc = "Comment selection" },
	{ "gc", mode = { "n", "o" }, desc = "Comment textobject" },
}

M.opts = {
	options = {
		custom_commentstring = function()
			return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
		end,
	},
}

---@type LazySpec[]
return {
	M,
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		opts = { enable_autocmd = false },
	},
	{
		"numToStr/Comment.nvim",
		opts = {
			extra = { eol = "gca" },
			opleader = { line = nil },
			toggler = { line = nil },
		},
		keys = {
			{
				"gb",
				mode = { "n", "v" },
				desc = "To[g]gle [b]lock comment",
			},
			{ "gca", desc = "[A]dd [c]omment at the end of the line" },
		},
	},
}
