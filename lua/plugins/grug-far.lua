---@type LazySpec
return {
	"MagicDuck/grug-far.nvim",
	cmd = { "GrugFar" },
	keys = {
		{
			"<leader>sr",
			mode = { "n", "v" },
			desc = "GrugFar: Search and Replace",
		},
	},
	config = function()
		local grug_far = require("grug-far")
		grug_far.setup()

		local map = Config.keymap("GrugFar")

		map("n", "<leader>sr", function()
			local filetype = vim.bo.buftype == "" and vim.fn.expand("%:e")
			grug_far.open({
				transient = true,
				prefills = { filesFilter = filetype and filetype ~= "" and "*." .. filetype or nil },
			})
		end, { desc = "Search and Replace" })
	end,
}
