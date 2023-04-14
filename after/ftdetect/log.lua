local api = vim.api

api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	callback = function() vim.bo.filetype = "log" end,
	desc = "Set filetype for log files",
	group = api.nvim_create_augroup("LogFiletype", {}),
	pattern = { "*.log", "*.error" },
})
