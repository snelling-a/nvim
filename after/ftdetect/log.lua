local utils = require("utils")

utils.autocmd({ "BufNewFile", "BufRead" }, {
	group = utils.augroup("LogFiletype", {}),
	pattern = { "*.log", "*.error" },
	callback = function() vim.bo.filetype = "log" end,
})
