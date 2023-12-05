---@type LazySpec
local M = { "echasnovski/mini.surround" }

M.keys = {
	{ "cs", desc = "Replace surrounding" },
	{ "csl", desc = "Replace previous surrounding" },
	{ "csn", desc = "Replace next surrounding" },
	{ "ds", desc = "Delete surrounding" },
	{ "dsl", desc = "Delete previous surrounding" },
	{ "dsn", desc = "Delete next surrounding" },
	{ "ys", mode = { "n", "v" }, desc = "Add surrounding" },
}

M.opts = {
	mappings = {
		add = "ys",
		delete = "ds",
		replace = "cs",
		highlight = "",
		find = "",
		find_left = "",
		update_n_lines = "",
	},
}

return M
