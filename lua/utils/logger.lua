local Logger = {}

local logger = vim.notify

Logger.levels = {
	info = vim.log.levels.INFO,
	warn = vim.log.levels.WARN,
	error = vim.log.levels.ERROR,
}

---@class LoggerArgs
---@field msg string?
---@field title string?
---@param logger_args LoggerArgs
---@return void
Logger.info = function(logger_args)
	logger(logger_args.msg or "", Logger.levels.info, { Title = logger_args.title or "Hey!" })
end

---@param logger_args LoggerArgs
Logger.warn = function(logger_args)
	logger(logger_args.msg or "", Logger.levels.warn, { Title = logger_args.title or "Listen!" })
end

---@param logger_args LoggerArgs
Logger.error = function(logger_args)
	logger(logger_args.msg or "", Logger.levels.error, { Title = logger_args.title or "Error!" })
end

return Logger
