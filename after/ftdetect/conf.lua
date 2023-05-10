local api = vim.api

api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = { "conf", "*.conf", "config", "*.config" },
	callback = function() vim.bo.filetype = "conf" end,
	group = require("config.util").augroup("ConfFiletype"),
})
