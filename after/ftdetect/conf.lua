local api = vim.api

api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	group = api.nvim_create_augroup("ConfFiletype", {}),
	pattern = { "conf", "*.conf", "config", "*.config" },
	callback = function() vim.bo.filetype = "conf" end,
})
