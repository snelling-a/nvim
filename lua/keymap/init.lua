require("keymap.command")
require("keymap.escape")
require("keymap.normal")
require("keymap.visual")

---@class Keymap
local M = setmetatable(require("keymap.util"), {
	__call = function(m, method)
		return m[method]
	end,
	__index = {
		center = require("keymap.center_actions"),
		leader = require("keymap.leader").map_leader,
		unimpaired = require("keymap.unimpaired").unimpaired,
	},
})

local map = M.map

map({ "n", "v" }, ";", ":", { desc = "Enter command mode with `;`", silent = false })
map({ "n", "v" }, ":", ";", { desc = "Command is remapped to `;`" })

map({ "n", "v" }, "z=", function()
	local word = vim.fn.expand("<cword>")
	local suggestions = vim.fn.spellsuggest(word)
	vim.ui.select(
		suggestions,
		{},
		vim.schedule_wrap(function(selected)
			if selected then
				vim.cmd.normal({ args = { ("ciw%s"):format(selected) }, bang = true })
			end
		end)
	)
end)

return M
