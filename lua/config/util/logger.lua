local levels = vim.log.levels
local titles = {
	[levels.INFO] = { tile = "Hey!" },
	[levels.WARN] = { tile = "Listen!" },
	[levels.ERROR] = { tile = "Error!" },
}

local Logger = {}

---@alias Message string?
---@alias Title string?
---@alias Level 0|1|2|3|4|5

---@param msg Message
---@param title Title
---@param level Level
local function log(level, title, msg)
	vim.defer_fn(function() vim.notify(msg or "", level, { title = title or titles[level].titletitle }) end, 500)
end

---@class LoggerArgs
---@field msg Message
---@field title Title

---@param logger_args LoggerArgs|string
function Logger.info(logger_args)
	if type(logger_args) == "string" then
		logger_args = { msg = logger_args }
	end
	log(levels.INFO, logger_args.title, logger_args.msg)
end

---@param logger_args LoggerArgs|string
function Logger.warn(logger_args)
	if type(logger_args) == "string" then
		logger_args = { msg = logger_args }
	end
	log(levels.WARN, logger_args.title, logger_args.msg)
end

---@param logger_args LoggerArgs|string
function Logger.error(logger_args)
	if type(logger_args) == "string" then
		logger_args = { msg = logger_args }
	end
	log(levels.ERROR, logger_args.title, logger_args.msg)
end

---@class ConfirmArgs
---@field msg string?
---@field choices string?
---@field default number?
---@field type string?
---@param confirm_args ConfirmArgs
---@return number confirmation
function Logger.confirm(confirm_args)
	local confirmation = vim.fn.confirm(
		confirm_args.msg or "Confirm",
		confirm_args.choices or "&Yes\n&No\n&Cancel",
		confirm_args.default or 1,
		confirm_args.type or "Question"
	)

	return confirmation
end

return Logger
