---@class user.qf
---@field statuscolumn user.qf.statuscolumn
---@field quickfixtextfunction user.qf.quickfixtextfunction
return setmetatable({}, {
	__index = function(_, k)
		return require("user.qf." .. k)
	end,
})
