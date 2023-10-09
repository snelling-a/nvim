local M = { "ofirgall/goto-breakpoints.nvim" }

function M.keys()
	local breakpoints = require("goto-breakpoints")

	return {
		{
			"]b",
			breakpoints.next,
			desc = "Go to next breakpoint",
		},
		{
			"[b",
			breakpoints.prev,
			"Go to previous breakpoint",
		},
	}
end

return M
