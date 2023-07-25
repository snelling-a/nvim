vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	callback = function() vim.bo.syntax = "typescriptreact" end,
	desc = "Set syntax for jsx files",
	group = require("config.util").augroup("JSXFiletype"),
	pattern = { "*.jsx" },
})
