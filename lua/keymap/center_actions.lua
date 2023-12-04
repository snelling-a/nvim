local Keymap = require("keymap.util")

local map = Keymap.nmap

---@class keymap.center_actions
local M = {}

--- Wrapper for |zz| (to scroll center) and |zv| (to open fold) keymaps
function M.scroll()
	Keymap.feedkeys("zz")
	Keymap.feedkeys("zv")
end

local function act_center(lhs)
	map(lhs, function()
		Keymap.feedkeys(lhs)
		M.scroll()
	end, { desc = ("Center screen after %s"):format(lhs) })
end
local function center_act(lhs)
	map(lhs, function()
		M.scroll()
		Keymap.feedkeys(lhs)
	end, { desc = ("Center screen before %s"):format(lhs) })
end

act_center("(")
act_center(")")
act_center("G")
act_center("N")
act_center("n")
act_center("zx")
act_center("{")
act_center("}")
act_center("zn")
act_center("zm")

center_act("<C-d>")
center_act("<C-u>")

map("za", "zazz", { desc = "Center screen after toggling a fold" })
map("zA", "zAzz", { desc = "Center screen after toggling a fold recursively" })

return M
