local M = { "echasnovski/mini.indentscope" }

M.event = { "BufReadPre", "BufNewFile" }

M.opts = {
	symbol = "│",
	options = { try_as_border = true },
}

function M.init()
	vim.api.nvim_create_autocmd("FileType", {
		pattern = vim.tbl_filter(function(ft) return ft ~= "alpha" end, require("config.util.constants").no_format),
		callback = function() vim.b.miniindentscope_disable = true end,
	})
end

return M
