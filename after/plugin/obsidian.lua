local obsidian = require("obsidian")
local utils = require("utils")

local api = vim.api
local cmd = vim.cmd
local vault_directory = os.getenv("NOTES") or os.getenv("HOME") .. "/notes"

local function note_id_func(input)
	local title = ""
	if input ~= nil then
		title = input:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
	end

	return os.date("!%Y-%m-%d") .. "-" .. title
end

obsidian.setup({
	completion = { nvim_cmp = true },
	daily_notes = { folder = "daily-notes" },
	dir = vault_directory,
	note_id_func = note_id_func,
	use_advanced_uri = true,
})

local function set_obsidian_links()
	if vim.fn.getcwd() ~= vault_directory then
		return
	end

	utils.nmap("<Leader>dn", cmd.ObsidianToday, { desc = "Open today's [d]aily [n]ote" })
	utils.nmap("<Leader>ob", cmd.ObsidianBacklinks, { desc = "[O]pen [b]acklinks" })
	utils.vmap("<Leader>ol", cmd.ObsidianLinkNew, { desc = "[O]pen [l]ink in new buffer" })
	utils.nmap("<Leader>on", cmd.ObsidianNew, { desc = "[O]pen [n]ew note" })
	utils.nmap("<Leader>ot", cmd.ObsidianToday, { desc = "[O]pen [t]oday's daily note" })
	utils.nmap("<Leader>oy", cmd.ObsidianYesterday, { desc = "[O]pen [y]esterday's daily note" })
	vim.keymap.set("n", "gf", function()
		if require("obsidian").util.cursor_on_markdown_link() then
			return "<cmd>ObsidianFollowLink<CR>"
		else
			return "gf"
		end
	end, { desc = "[F]ollow link", noremap = false, expr = true })
end

api.nvim_create_autocmd("FileType", {
	callback = function() set_obsidian_links() end,
	desc = "Set Obsidian keymaps",
	group = api.nvim_create_augroup("Obsidian", { clear = false }),
	pattern = "markdown",
})
