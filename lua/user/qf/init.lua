---@class user.qf
---@field quickfixtextfunction user.qf.quickfixtextfunction
return setmetatable({}, {
	__index = function(_, k)
		return require("user.qf." .. k)
	end,
})
