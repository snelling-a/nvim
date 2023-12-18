---@type LazySpec
local M = { "RRethy/vim-illuminate" }

M.event = require("util").constants.lazy_event

M.opts = {
	delay = 200,
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

	local function map(key, dir, buffer)
		vim.keymap.set("n", key, function()
			require("illuminate")["goto_" .. dir .. "_reference"](false)
		end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
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
