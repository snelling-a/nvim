local M = {
	"chrisgrieser/nvim-spider",
}

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

M.event = "BufAdd"

return M
