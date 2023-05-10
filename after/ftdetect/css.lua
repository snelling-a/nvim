local api = vim.api

api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	callback = function() vim.bo.filetype = "css" end,
	desc = "Set filetype for css files",
	group = require("config.util").augroup("CSSFiletype"),
	pattern = { "*.pcss" },
})
