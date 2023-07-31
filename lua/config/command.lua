local command = vim.api.nvim_create_user_command
local api = vim.api
local cmd = vim.cmd

command("SortJSON", function() cmd("%!jq . --sort-keys") end, { desc = "Sort json keys alphabetically" })

command("SortYAML", function() cmd("%!yq 'sort_keys(..)' %") end, { desc = "Sort yaml keys alphabetically" })

command("SpellCheck", function(ctx)
	local target = ctx.args or "**"

	if target == "%" then
		---@diagnostic disable-next-line: cast-local-type
		target = vim.fn.expand(target)
	end

	os.execute("cspell --unique --words-only --gitignore " .. target .. " | sort > z_spell.txt")
end, {
	nargs = "?",
	complete = function() return { "**", "%" } end,
	desc = "Check spelling",
})

command("ColorMyPencils", function()
	local normal = api.nvim_get_hl(0, { name = "Normal" })
	local normal_float = api.nvim_get_hl(0, { name = "NormalFloat" })

	if vim.tbl_get(normal_float, "bg") or vim.tbl_get(normal, "bg") then
		api.nvim_set_hl(0, "Normal", { bg = "none" })
		api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
	else
		cmd.colorscheme(vim.g.colors_name)
	end
end, { desc = "Toggle transparent background" })

command(
	"StripWhitespace",
	function() cmd.substitute([[/\s\+$/]], [[\=submatch(0)]], [[e]]) end,
	{ desc = "Strip whitespace from the end of the line" }
)

command("GenrateAverageColor", function() require("config.ui.average-colorscheme") end, {})
