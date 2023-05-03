local M = { "numToStr/Comment.nvim" }

M.dependencies = "nvim-treesitter/nvim-treesitter"

M.keys = {
	{ "gc", mode = { "n", "v" }, desc = "To[g]gle [c]omment" },
	{ "gb", mode = { "n", "v" }, desc = "To[g]gle [b]lock comment" },
}

function M.opts()
	local commentstring_avail, commentstring = pcall(require, "ts_context_commentstring.integrations.comment_nvim")
	return commentstring_avail and commentstring and { pre_hook = commentstring.create_pre_hook() } or {}
end

return M
