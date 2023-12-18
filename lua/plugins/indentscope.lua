---@type LazySpec
local M = { "echasnovski/mini.indentscope" }

M.event = require("util").constants.lazy_event

M.opts = {
	symbol = require("ui.icons").misc.leadmultispace,
	-- options = { try_as_border = true },
}

function M.config(_, opts)
	require("mini.indentscope").setup(opts)
	vim.api.nvim_create_autocmd({ "FileType" }, {
		callback = function()
			vim.b.miniindentscope_disable = true
		end,
		group = require("autocmd").augroup("MiniIndentScopeDisable"),
		pattern = require("util").constants.no_format,
	})
end

return M
