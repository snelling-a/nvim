local command = vim.api.nvim_create_user_command

command("SortJSON", function() vim.cmd("%!jq . --sort-keys") end, { desc = "Sort json keys alphabetically" })

command("SortYAML", function() vim.cmd("%!yq 'sort_keys(..)' %") end, { desc = "Sort yaml keys alphabetically" })

command(
	"SpellCheck",
	function() os.execute("cspell --unique --words-only --gitignore ** | sort > z_spell.txt") end,
	{ desc = "Toggle spell check" }
)
