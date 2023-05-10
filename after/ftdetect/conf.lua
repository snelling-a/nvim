local api = vim.api

api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	callback = function() vim.bo.filetype = "conf" end,
	desc = "Set filetype for conf files",
	group = require("config.util").augroup("ConfFiletype"),
	pattern = { "conf", "*.conf", "config", "*.config" },
})
