local api = vim.api

api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	group = api.nvim_create_augroup("JSXFiletype", {}),
	pattern = { "*.jsx" },
	callback = function() vim.bo.syntax = "typescriptreact" end,
})
