local api = vim.api

api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = { "*.pcss" },
	callback = function() vim.bo.filetype = "css" end,
	group = require("config.util").augroup("CSSFiletype"),
})
