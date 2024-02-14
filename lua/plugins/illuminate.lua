---@type LazySpec
local M = { "RRethy/vim-illuminate" }

M.event = require("util").constants.lazy_event

M.opts = {
	filetypes_denylist = require("util").constants.no_format,
	large_file_cutoff = 2000,
	large_file_overrides = {
		providers = { "lsp" },
	},
	under_cursor = false,
}

M.keys = {
	{ "]]", desc = "Next Reference" },
	{ "[[", desc = "Prev Reference" },
}

function M.config(_, opts)
	require("illuminate").configure(opts)

	---@param lhs "]]"|"[[""
	---@param dir "next"|"prev"
	---@param buffer integer?
	local function map(lhs, dir, buffer)
		local method = ("goto_%s_reference"):format(dir)
		local desc = ("Go to %s Reference"):format(dir)

		require("keymap").nmap(lhs, function()
			require("illuminate")[method](false)
		end, { desc = desc, buffer = buffer })
	end

	map("]]", "next")
	map("[[", "prev")

	vim.api.nvim_create_autocmd("FileType", {
		callback = function()
			local buffer = vim.api.nvim_get_current_buf()
			map("]]", "next", buffer)
			map("[[", "prev", buffer)
		end,
	})
end

return M
