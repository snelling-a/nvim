local desc = "Better [gx]"

---@type LazySpec
local M = { "chrishrb/gx.nvim" }

M.dependencies = { "nvim-lua/plenary.nvim" }

M.keys = {
	{
		"gx",
		mode = { "n", "v" },
		desc = desc,
	},
}

M.opts = {
	handler_options = { search_engine = "ecosia" },
}

function M.config(_, opts)
	require("gx").setup(opts)

	require("keymap").map({ "n", "x" }, "gx", vim.cmd.Browse, { desc = desc })
end

return M
