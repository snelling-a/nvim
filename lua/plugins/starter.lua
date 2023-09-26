local Icons = require("config.ui.icons")

--- @type LazySpec
local M = {
	"echasnovski/mini.starter",
}

local function pad_10(content)
	local empty_item = { { type = "empty", string = "" } }

	for i = 1, 10 do
		-- NOTE: for some reason, the header renders twice
		local pos = i % 2 == 0 and 3 or #content - 1

		table.insert(content, pos, empty_item)
	end

	return content
end

function M.opts()
	local pad = string.rep(" ", 16)
	local new_item = function(name, action, section)
		return {
			action = action,
			name = name,
			section = pad .. section,
		}
	end

	local starter = require("mini.starter")

	return {
		evaluate_single = true,
		header = " ▌║█║▌│║▌│║▌║▌█║  neovim  ▌│║▌║▌│║║▌█║▌║█ ",
		items = {
			new_item("Find file", "FzfLua files", "Find"),
			new_item("Old files", "FzfLua oldfiles", "Find"),
			new_item("Grep text", "FzfLua live_grep", "Find"),
			new_item("Lazy", "Lazy", "Config"),
			new_item("Mason", "Mason", "Config"),
			new_item("MasonUpdateAll", "MasonUpdateAll", "Config"),
			new_item("GenerateAverageColor", "GenerateAverageColor", "Colors"),
			new_item("Session restore", "SessionLoad", "Session"),
			new_item("Checkhealth", "checkhealth", "Built-in"),
			new_item("Quit", "qa", "Built-in"),
		},
		content_hooks = {
			pad_10,
			starter.gen_hook.adding_bullet(pad .. "░ ", false),
			starter.gen_hook.aligning("center", "center"),
		},
	}
end

M.event = {
	"VimEnter",
}

function M.config(_, opts)
	if vim.o.filetype == "lazy" then
		vim.cmd.close()
		vim.api.nvim_create_autocmd("User", {
			pattern = "MiniStarterOpened",
			callback = function() require("lazy").show() end,
		})
	end

	local starter = require("mini.starter")
	starter.setup(opts)

	vim.api.nvim_create_autocmd("User", {
		pattern = "LazyVimStarted",
		callback = function()
			local stats = require("lazy").stats()
			local v = vim.version()

			local version = string.format("%s %d.%d.%d", Icons.misc.version, v.major, v.minor, v.patch)

			local time = (math.floor(stats.startuptime * 100 + 0.5) / 100)
			local startup_time = string.format("%s %d ms", Icons.progress.pending, time)

			local plugins = string.format("%s\t\t%d / %d\t\tPlugins", Icons.misc.rocket, stats.loaded, stats.count)

			starter.config.footer = string.format("%s %s %s", version, plugins, startup_time)

			vim.opt_local.statusline = " "

			pcall(starter.refresh)
		end,
	})
end

return M
