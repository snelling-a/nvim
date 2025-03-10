---@type LazySpec
return {
	"echasnovski/mini.surround",
	keys = {
		{ "cs", desc = "MiniSurround: Replace Surrounding" },
		{ "ds", desc = "MiniSurround: Delete Surrounding" },
		{ "S", desc = "MiniSurround: Add Surrounding", mode = { "x" } },
		{ "ys", desc = "MiniSurround: Add Surrounding" },
		{ "yss", desc = "MiniSurround: Add Surrounding to Line" },
	},
	config = function()
		require("mini.surround").setup({
			mappings = {
				add = "ys",
				delete = "ds",
				find = "",
				find_left = "",
				highlight = "",
				replace = "cs",
				suffix_last = "",
				suffix_next = "",
				update_n_lines = "",
			},
			search_method = "cover_or_next",
		})

		vim.keymap.del("x", "ys")

		local map = require("user.keymap.util").map("MiniSurround")

		map("x", "S", [[:<C-u>lua MiniSurround.add('visual')<CR>]], { desc = "Add Surrounding" })
		map("n", "yss", "ys_", { desc = "Add Surrounding to Line", remap = true })
	end,
}
