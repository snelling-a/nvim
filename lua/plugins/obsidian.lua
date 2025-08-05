---@type LazySpec
return {
	"obsidian-nvim/obsidian.nvim",
	event = { "BufReadPre " .. vim.fn.expand("~") .. "/notes/*.md" },
	lazy = true,
	version = "*",
	---@type obsidian.config.ClientOpts
	---@diagnostic disable-next-line: missing-fields
	opts = {
		---@diagnostic disable-next-line: missing-fields
		completion = { blink = true },
		---@diagnostic disable-next-line: missing-fields
		daily_notes = { folder = "daily_notes", template = "daily_note" },
		legacy_commands = false,
		note_frontmatter_func = function(note)
			if note.title then
				note:add_alias(note.title)
			end
			local out = { aliases = note.aliases }
			if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
				for k, v in pairs(note.metadata) do
					out[k] = v
				end
			end
			return out
		end,
		---@diagnostic disable-next-line: missing-fields
		picker = { name = "mini.pick" },
		---@diagnostic disable-next-line: missing-fields
		templates = { folder = "templates" },
		workspaces = {
			{ name = "notes", path = "~/notes" },
		},
	},
}
