local logger = require("utils.logger")
local obsidian = require("obsidian")
local utils = require("utils")

local vault_directory = os.getenv("NOTES") or os.getenv("HOME") .. "/notes"

obsidian.setup({
	dir = vault_directory,
	completion = { nvim_cmp = true },
	daily_notes = { folder = "daily-notes" },
	use_advanced_uri = true,
	note_id_func = function(input)
		local title = ""
		if input ~= nil then
			-- If title is given, transform it into valid file name.
			title = input:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
		else
			-- If title is nil, just add 4 random uppercase letters to the suffix.
			for _ = 1, 4 do
				title = title .. string.char(math.random(65, 90))
			end
		end

		return os.date("!%Y-%m-%d") .. "-" .. title
	end,
})

local ObsidianGroup = utils.augroup("Obsidian", { clear = false })
utils.autocmd("FileType", {
	group = ObsidianGroup,
	pattern = "markdown",
	callback = function()
		if vim.fn.getcwd() ~= vault_directory then
			return
		end

		utils.nmap("<Leader>dn", function() vim.cmd.ObsidianToday() end)
		utils.nmap("<Leader>ob", function() vim.cmd.ObsidianBacklinks() end)
		utils.vmap("<Leader>ol", function() vim.cmd.ObsidianLinkNew() end)
		utils.nmap("<Leader>on", function() vim.cmd.ObsidianNew() end)
		utils.nmap("<Leader>os", function() vim.cmd.ObsidianSearch() end)
		utils.nmap("<Leader>ot", function() vim.cmd.ObsidianToday() end)
		utils.nmap("<Leader>oy", function() vim.cmd.ObsidianYesterday() end)
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

utils.autocmd("BufEnter", {
	group = ObsidianGroup,
	pattern = vault_directory .. "/**.md",
	callback = function()
		vim.defer_fn(function()
			-- vim.cmd.ObsidianBacklinks()
			-- vim.cmd.wincmd("p")
			logger.info({ msg = "ObsidianBacklinks" })
		end, 100)
	end,
	-- command = "ObsidianBacklinks",
})
