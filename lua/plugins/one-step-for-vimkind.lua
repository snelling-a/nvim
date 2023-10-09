local M = {
	"jbyuki/one-small-step-for-vimkind",
}

M.keys = {
	{
		"<F12>",
		function() require("dap.ui.widgets").hover() end,
		desc = "",
	},
	{
		"<F9>",
		function()
			require("osv").launch({
				port = 8086,
			})
		end,
		desc = "",
	},
}

return M
