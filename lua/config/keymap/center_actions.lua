local util = require("config.util")

local function act_center(lhs)
	util.map(
		{
			"n",
		},
		lhs,
		function()
			util.feedkeys(lhs)
			util.scroll_center()
		end,
		{
			desc = "Center screen after " .. lhs,
		}
	)
end
local function center_act(lhs)
	util.map(
		{
			"n",
		},
		lhs,
		function()
			util.scroll_center()
			util.feedkeys(lhs)
		end,
		{
			desc = "Center screen before " .. lhs,
		}
	)
end

act_center("G")
act_center("N")
act_center("n")
act_center("}")
act_center("{")
act_center(")")
act_center("(")

center_act("<C-d>")
center_act("<C-u>")
center_act("A")
center_act("a")
center_act("I")
center_act("i")
center_act("O")
center_act("o")
center_act("S")
center_act("s")

util.map("n", "c", "zzzvc", {
	desc = "Center screen after c",
})
util.map("n", "C", "zzzvC", {
	desc = "Center screen after C",
})
