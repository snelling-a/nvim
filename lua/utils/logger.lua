local Logger = {}

local logger = vim.notify

Logger.levels = {
	info = vim.log.levels.INFO,
	warn = vim.log.levels.WARN,
	error = vim.log.levels.ERROR,
}

Logger.info = function(logger_args)
	logger(logger_args.msg or "", Logger.levels.info, { Title = logger_args.title or "Hey!" })
end

Logger.warn = function(logger_args)
	logger(logger_args.msg or "", Logger.levels.warn, { Title = logger_args.title or "Listen!" })
end

Logger.error = function(logger_args)
	logger(logger_args.msg or "", Logger.levels.error, { Title = logger_args.title or "Error!" })
end

return Logger
