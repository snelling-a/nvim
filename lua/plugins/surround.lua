---@type LazySpec
return {
	"echasnovski/mini.surround",
	keys = {
		{ "cs", desc = "Replace Surrounding" },
		{ "ds", desc = "Delete Surrounding" },
		{ "S", desc = "Add Surrounding", mode = { "x" } },
		{ "ys", desc = "Add Surrounding" },
		{ "yss", desc = "Add Surrounding to Line" },
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

		local map = Config.keymap("MiniSurround")

		map("x", "S", [[:<C-u>lua MiniSurround.add('visual')<CR>]], { desc = "Add Surrounding" })
		map("n", "yss", "ys_", { desc = "Add Surrounding to Line", remap = true })
	end,
}
