--- @type LazySpec
local M = {
	"chrisgrieser/nvim-spider",
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
			desc = ("Spider-%s"):format(v),
			mode = mode,
		})
	end

	return keys
end

return M
