local levels = vim.log.levels
local titles = {
	[levels.INFO] = { tile = "Hey!" },
	[levels.WARN] = { tile = "Listen!" },
	[levels.ERROR] = { tile = "Error!" },
}

---@alias Message string?
---@alias Title string?
---@alias Level 0|1|2|3|4|5

---@class NotifyArgs
---@field msg Message?
---@field title Title?

---@alias LoggerArgs NotifyArgs|string?

---@param args LoggerArgs
---@return NotifyArgs logger_args
local function get_logger_args(args, title)
	local logger_args = { title = title }

	if type(args) == "table" and type(args.msg) == "string" then
		logger_args.msg = args.msg
		logger_args.title = type(args.title) == "string" and args.title or title
	end

	if type(args) == "string" then
		logger_args.msg = args
	elseif type(args) == "nil" then
		logger_args.msg = title
	end

	return logger_args
end

local Logger = {}

---@param level Level
---@param args LoggerArgs
local function log(level, args)
	local logger_args = get_logger_args(args, titles[level].title)

	vim.defer_fn(function() vim.notify(logger_args.msg, level, { title = logger_args.title }) end, 500)
end

---@param logger_args LoggerArgs
function Logger.info(logger_args) log(levels.INFO, logger_args) end

---@param logger_args LoggerArgs
function Logger.warn(logger_args) log(levels.WARN, logger_args) end

---@param logger_args LoggerArgs
function Logger.error(logger_args) log(levels.ERROR, logger_args) end

---@class ConfirmArgs
---@field msg string?
---@field choices string?
---@field default number?
---@field type string?

---@param confirm_args ConfirmArgs
---@return number|nil confirmation
function Logger.confirm(confirm_args)
	return vim.fn.confirm(
		confirm_args.msg or "Confirm",
		confirm_args.choices or "&Yes\n&No\n&Cancel",
		confirm_args.default or 1,
		confirm_args.type or "Question"
	)
end

return Logger
