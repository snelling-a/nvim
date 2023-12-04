---@type LazySpec
local M = { "ggandor/flit.nvim" }

M.dependencies = { "ggandor/leap.nvim" }

M.opts = { labeled_modes = "nx" }

---@diagnostic disable-next-line: assign-type-mismatch
function M.keys()
	local keys = {}

	for _, key in ipairs({ "f", "F", "t", "T" }) do
		keys[#keys + 1] = {
			key,
			mode = { "n", "x", "o" },
			desc = key,
		}
	end

	return keys
end

return M
