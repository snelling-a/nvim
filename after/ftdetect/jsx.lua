local api = vim.api

api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = { "*.jsx" },
	callback = function() vim.bo.syntax = "typescriptreact" end,
	group = require("config.util").augroup("JSXFiletype"),
})
