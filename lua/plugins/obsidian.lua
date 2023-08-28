local obsidian = require("config.util.constants").obsidian
local cmd = vim.cmd

local function note_id_func(input)
	if input ~= nil then
		input = input:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
	end

	local title = (input and "-" .. input) or ""
	return os.date("%Y%m%d%H%M") .. title
end



local M = {
	"epwalsh/obsidian.nvim",
}

M.dependencies = {
	"hrsh7th/nvim-cmp",
	"ibhagwan/fzf-lua",
	"nvim-lua/plenary.nvim",
	"nvim-treesitter/nvim-treesitter",
}

M.event = {
	"BufReadPre " .. obsidian.vault_directory .. "/*",
}

M.ft = "markdown"

M.keys = {
	{
		"<leader>dn",
		cmd.ObsidianToday,
		desc = "Open today's [d]aily [n]ote",
	},
	{
		"<leader>ob",
		cmd.ObsidianBacklinks,
		desc = "[O]pen [b]acklinks",
	},
	{
		"<leader>ol",
		cmd.ObsidianLinkNew,
		desc = "[O]pen [l]ink in new buffer",
	},
	{
		"<leader>on",
		cmd.ObsidianNew,
		desc = "[O]pen [n]ew note",
	},
	{
		"<leader>os",
		cmd.ObsidianSearch,
		desc = "[O]bsidian [s]earch",
	},
	{
		"<leader>ot",
		cmd.ObsidianToday,
		desc = "[O]pen [t]oday's daily note",
	},
	{
		"<leader>oy",
		cmd.ObsidianYesterday,
		desc = "[O]pen [y]esterday's daily note",
	},
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

M.lazy = not obsidian.is_vault_directory

M.opts = {
	completion = {
		nvim_cmp = true,
	},
	daily_notes = {
		folder = "daily_notes",
	},
	dir = obsidian.vault_directory,
	finder = "fzf-lua",
	note_id_func = note_id_func,
	open_app_foreground = true,
	templates = {
		subdir = "templates",
	},
	use_advanced_uri = true,
	note_frontmatter_func = note_frontmatter_func,
}

return M
