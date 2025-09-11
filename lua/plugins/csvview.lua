---@type LazySpec
return {
	"hat0uma/csvview.nvim",
	cmd = { "CsvViewEnable", "CsvViewToggle" },
	---@module "csvview"
	---@type CsvView.Options
	opts = {
		display_mode = "highlight",
		parser = {
			comments = { "#", "//" },
		},
		keymaps = {
			jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
			jump_next_row = { "<Enter>", mode = { "n", "v" } },
			jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
			jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
			textobject_field_inner = { "if", mode = { "o", "x" } },
			textobject_field_outer = { "af", mode = { "o", "x" } },
		},
	},
}
