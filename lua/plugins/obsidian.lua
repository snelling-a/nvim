local obsidian = require("config.util.constants").obsidian
local cmd = vim.cmd

local function note_id_func(input)
	local title = "Untitled"
	if input ~= nil then
		title = input:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
	end

	return os.date("%Y%m%d%H%M") .. "-" .. title
end

local Obsidian = { "epwalsh/obsidian.nvim" }

Obsidian.dependencies =
	{ "hrsh7th/nvim-cmp", "ibhagwan/fzf-lua", "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" }

Obsidian.event = { "BufReadPre " .. obsidian.vault_directory .. "/*" }

Obsidian.ft = "markdown"

Obsidian.keys = {
	{ "<leader>dn", cmd.ObsidianToday, desc = "Open today's [d]aily [n]ote" },
	{ "<leader>ob", cmd.ObsidianBacklinks, desc = "[O]pen [b]acklinks" },
	{ "<leader>ol", cmd.ObsidianLinkNew, desc = "[O]pen [l]ink in new buffer" },
	{ "<leader>on", cmd.ObsidianNew, desc = "[O]pen [n]ew note" },
	{ "<leader>ot", cmd.ObsidianToday, desc = "[O]pen [t]oday's daily note" },
	{ "<leader>oy", cmd.ObsidianYesterday, desc = "[O]pen [y]esterday's daily note" },
	{
		"gf",
		function()
			if require("obsidian").util.cursor_on_markdown_link() then
				return vim.cmd.ObsidianFollowLink()
			else
				return "gf"
			end
		end,
		desc = "[F]ollow link",
	},
}

Obsidian.lazy = not obsidian.is_vault_directory

Obsidian.opts = {
	completion = { nvim_cmp = true },
	daily_notes = { folder = "daily_notes" },
	dir = obsidian.vault_directory,
	note_id_func = note_id_func,
	open_app_foreground = true,
	use_advanced_uri = true,
}

return Obsidian
