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

local ObsidianGroup = api.nvim_create_augroup("Obsidian", { clear = false })
api.nvim_create_autocmd("FileType", {
	group = ObsidianGroup,
	pattern = "markdown",
	callback = function()
		if vim.fn.getcwd() ~= vault_directory then
			return
		end

		utils.nmap("<Leader>dn", function() cmd.ObsidianToday() end)
		utils.nmap("<Leader>ob", function() cmd.ObsidianBacklinks() end)
		utils.vmap("<Leader>ol", function() cmd.ObsidianLinkNew() end)
		utils.nmap("<Leader>on", function() cmd.ObsidianNew() end)
		utils.nmap("<Leader>os", function() cmd.ObsidianSearch() end)
		utils.nmap("<Leader>ot", function() cmd.ObsidianToday() end)
		utils.nmap("<Leader>oy", function() cmd.ObsidianYesterday() end)
		vim.keymap.set("n", "gf", function()
			if require("obsidian").util.cursor_on_markdown_link() then
				return "<cmd>ObsidianFollowLink<CR>"
			else
				return "gf"
			end
		end, { noremap = false, expr = true })
	end,
	desc = "Obsidian keymaps",
})
