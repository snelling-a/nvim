local api = vim.api

api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	group = api.nvim_create_augroup("CSSFiletype", {}),
	pattern = { "*.pcss" },
	callback = function() vim.bo.filetype = "css" end,
})
