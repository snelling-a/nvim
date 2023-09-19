local Util = require("config.util")

local function act_center(lhs)
	Util.map(
		{
			"n",
		},
		lhs,
		function()
			Util.feedkeys(lhs)
			Util.scroll_center()
		end,
		{
			desc = "Center screen after " .. lhs,
		}
	)
end
local function center_act(lhs)
	Util.map(
		{
			"n",
		},
		lhs,
		function()
			Util.scroll_center()
			Util.feedkeys(lhs)
		end,
		{
			desc = "Center screen before " .. lhs,
		}
	)
end

act_center("(")
act_center(")")
act_center("G")
act_center("N")
act_center("n")
act_center("zj")
act_center("zk")
act_center("zx")
act_center("{")
act_center("}")

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

Util.map("n", "c", "zzzvc", {
	desc = "Center screen before c",
})
Util.map("n", "C", "zzzvC", {
	desc = "Center screen before C",
})
Util.map("n", "za", "zazz", {
	desc = "Center screen before c",
})
Util.map("n", "zA", "zAzz", {
	desc = "Center screen before C",
})
