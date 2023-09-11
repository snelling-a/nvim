local levels = vim.log.levels

--- @class Log
local M = {}

function M:new(title)
	self = setmetatable({
		title = title,
	}, {
		__index = self,
	})
	self.title = title

	return self
end

function M:get_logger_args(args)
	--- @type NotifyArgs
	local logger_args = { title = self.title }

	if type(args) == "table" then
		logger_args.title = type(args.title) == "string" and args.title or logger_args.title

		if args.msg then
			logger_args.msg = type(args.msg) == "string" and args.msg or vim.inspect(args.msg)
		end
	end

	if type(args) == "string" then
		logger_args.msg = args
	elseif type(args) == "nil" then
		logger_args.msg = ""
	end

	return logger_args
end

function M:log(level, args)
	local logger_args = self:get_logger_args(args)

	vim.defer_fn(function()
		vim.notify(logger_args.msg, level, {
			title = logger_args.title,
		})
	end, 500)
end

function M:info(args) self:log(levels.INFO, args) end
function M:warn(args) self:log(levels.WARN, args) end
function M:error(args) self:log(levels.ERROR, args) end

function M:confirm(confirm_args)
	local msg = (confirm_args.msg and self.title) and (self.title .. ": " .. confirm_args.msg)
		or confirm_args.msg
		or "Confirm"

	return vim.fn.confirm(
		msg,
		confirm_args.choices or "&Yes\n&No\n&Cancel",
		confirm_args.default or 1,
		confirm_args.type or "Question"
	)
end

return M
