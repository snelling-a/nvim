---@type LazySpec
return {
	"obsidian-nvim/obsidian.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	event = {
		"BufReadPre " .. vim.fn.expand("~") .. "/notes/*.md",
	},
	ft = "markdown",
	lazy = true,
	version = "*",
	opts = {
		completion = { blink = true },
		daily_notes = { folder = "daily_notes", template = "daily_note" },
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
		picker = { name = "mini.pick" },
		templates = { folder = "templates" },
		workspaces = {
			{ name = "notes", path = "~/notes" },
		},
	},
}
