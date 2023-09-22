--- @type LazySpec
local M = {
	"numToStr/Comment.nvim",
}

M.keys = {
	---@diagnostic disable-next-line: missing-fields
	{
		"gc",
		mode = {
			"n",
			"v",
		},
		desc = "To[g]gle [c]omment",
	},
	---@diagnostic disable-next-line: missing-fields
	{
		"gb",
		mode = {
			"n",
			"v",
		},
		desc = "To[g]gle [b]lock comment",
	},
}

function M.opts()
	local ok, commentstring = pcall(require, "ts_context_commentstring.integrations.comment_nvim")

	return ok and commentstring and {
		pre_hook = commentstring.create_pre_hook(),
	} or {}
end

return M
