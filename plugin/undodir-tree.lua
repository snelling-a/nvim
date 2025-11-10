if vim.g.undodir_tree_loaded then
	return
end
vim.g.undodir_tree_loaded = true

local UndodirTree = require("user.undodir-tree")
local group = require("user.autocmd").augroup("undodirtree")
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	group = group,
	desc = "Save undo history to undodir-tree",
	pattern = "*",
	callback = UndodirTree.write_undo,
})
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
	callback = UndodirTree.read_undo,
	desc = "Load undo history from undodir-tree",
	group = group,
	pattern = "*",
})
