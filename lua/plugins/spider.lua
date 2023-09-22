--- @type LazySpec
local M = {
	"chrisgrieser/nvim-spider",
}

M.event = {
	"BufAdd",
}

---@diagnostic disable-next-line: assign-type-mismatch
function M.keys()
	local mode = {
		"n",
		"o",
		"x",
	}
	local motions = {
		"w",
		"e",
		"b",
		"ge",
	}

	local keys = {}

	for _, v in ipairs(motions) do
		table.insert(keys, {
			v,
			function() require("spider").motion(v) end,
			desc = string.format("Spider-%s", v),
			mode = mode,
		})
	end

	return keys
end

return M
