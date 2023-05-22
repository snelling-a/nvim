local M = { "echasnovski/mini.indentscope" }

M.event = { "BufReadPre", "BufNewFile" }

M.opts = {
	symbol = require("config.ui.icons").fillchars.foldsep,
	options = { try_as_border = true },
}

M.version = "*"

function M.init()
	vim.api.nvim_create_autocmd("FileType", {
		callback = function() vim.b.miniindentscope_disable = true end,
		group = require("config.util").augroup("Indentscope"),
		pattern = require("config.util.constants").no_format,
	})
end

return M
