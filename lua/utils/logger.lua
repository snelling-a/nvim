local Logger = {}

local logger = vim.notify

local levels = {
	info = vim.log.levels.INFO,
	warn = vim.log.levels.WARN,
	error = vim.log.levels.ERROR,
}

---@class LoggerArgs
---@field msg string?
---@field title string?
---@param logger_args LoggerArgs
Logger.info = function(logger_args) --
	logger(logger_args.msg or "", levels.info, { Title = logger_args.title or "Hey!" })
end

---@param logger_args LoggerArgs
Logger.warn = function(logger_args)
	logger(logger_args.msg or "", levels.warn, { Title = logger_args.title or "Listen!" })
end

---@param logger_args LoggerArgs
Logger.error = function(logger_args)
	logger(logger_args.msg or "", levels.error, { Title = logger_args.title or "Error!" })
end

---@class ConfirmArgs
---@field msg string?
---@field choices string?
---@field default number?
---@field type string?
---@param confirm_args ConfirmArgs
---@return number confirmation
Logger.confirm = function(confirm_args)
	local confirmation = vim.fn.confirm(
		confirm_args.msg or "Confirm",
		confirm_args.choices or "&Yes\n&No\n&Cancel",
		confirm_args.default or 1,
		confirm_args.type or "Question"
	)

	return confirmation
end

return Logger
