local api = vim.api

api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	group = api.nvim_create_augroup("LogFiletype", {}),
	pattern = { "*.log", "*.error" },
	callback = function() vim.bo.filetype = "log" end,
})
