local command = vim.api.nvim_create_user_command

command("SortJSON", function() vim.cmd("%!jq . --sort-keys") end, { desc = "Sort json keys alphabetically" })

command("SortYAML", function() vim.cmd("%!yq 'sort_keys(..)' %") end, { desc = "Sort yaml keys alphabetically" })

command(
	"SpellCheck",
	function() os.execute("cspell --unique --words-only --gitignore ** | sort > z_spell.txt") end,
	{ desc = "Toggle spell check" }
)

command("ColorMyPencils", function()
	local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
	local normal_float = vim.api.nvim_get_hl(0, { name = "NormalFloat" })

	if vim.tbl_get(normal_float, "bg") or vim.tbl_get(normal, "bg") then
		vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
	else
		vim.cmd.colorscheme(vim.g.colors_name)
	end
end, { desc = "Toggle transparent background" })
