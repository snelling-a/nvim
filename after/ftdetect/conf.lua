local utils = require("utils")

utils.autocmd({ "BufNewFile", "BufRead" }, {
	group = utils.augroup("ConfFiletype", {}),
	pattern = { "conf", "*.conf", "config", "*.config", "*rc" },
	callback = function() vim.bo.filetype = "conf" end,
})
