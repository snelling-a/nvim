---@type LazySpec
local M = { "echasnovski/mini.starter" }

M.cond = vim.fn.argc(-1) == 0 and require("util").is_vim()

-- M.event = { "VimEnter" }

---@diagnostic disable-next-line: assign-type-mismatch
M.init = false

M.lazy = false

--- add 16 spaces
local pad = string.rep(" ", 16)

function M.config(_, opts)
	if vim.o.filetype == "lazy" then
		vim.cmd.close()
		vim.api.nvim_create_autocmd("User", {
			pattern = "MiniStarterOpened",
			callback = function()
				vim.opt_local.statuscolumn = ""
				require("lazy").show()
			end,
		})
	end

	require("mini.starter").setup(opts)

	vim.opt_local.statuscolumn = ""
end

function M.opts()
	local function pad_10(content)
		local empty_item = {
			{ type = "empty", string = "" },
		}

		for i = 1, 6 do
			-- NOTE: for some reason, the header renders twice
			local pos = i % 2 == 0 and 3 or #content - 1

			table.insert(content, pos, empty_item)
		end

		return content
	end

	local starter = require("mini.starter")
	local content_hooks = {
		pad_10,
		starter.gen_hook.adding_bullet(("%s░ "):format(pad), false),
		starter.gen_hook.aligning("center", "center"),
	}

	local vim_version = vim.version()
	local version = ("%s %d.%d.%d"):format(
		require("ui.icons").misc.version,
		vim_version.major,
		vim_version.minor,
		vim_version.patch
	)

	local new_item = function(name, action, section)
		return { name = name, action = action, section = ("%s%s"):format(pad, section) }
	end

	local items = {
		new_item("Find file", "FzfLua files", "Find"),
		new_item("Old files", "FzfLua oldfiles", "Find"),
		new_item("Grep text", "FzfLua live_grep", "Find"),
		new_item("Lazy", "Lazy", "Config"),
		new_item("Mason", "Mason", "Config"),
		new_item("Checkhealth", "checkhealth", "Built-in"),
		new_item("Session restore", "SessionLoad", "Session"),
		new_item("Quit", "qa", "Built-in"),
	}
	return {
		content_hooks = content_hooks,
		evaluate_single = true,
		footer = (" %s%s"):format(pad, version),
		header = " ▌║█║▌│║▌│║▌║▌█║  neovim  ▌│║▌║▌│║║▌█║▌║█ ",
		items = items,
		silent = true,
	}
end

return M
