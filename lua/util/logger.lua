local levels = vim.log.levels

---@class Logger
local M = {}

function M:new(title)
	self = setmetatable({
		title = ("[%s]"):format(title),
	}, {
		__index = self,
	})

	return self
end

function M.get_logger_args(args)
	local msg = args.msg or args

	if type(msg) == "table" then
		msg = table.concat(
			vim.tbl_filter(function(line)
				return line or false
			end, msg),
			"\n"
		)
	end

	return msg
end

function M:log(level, args)
	local msg = M.get_logger_args(args)
	if vim.in_fast_event() then
		return vim.schedule(function()
			self:log(level, args)
		end)
	end

	local n = args.once and vim.notify_once or vim.notify
	vim.defer_fn(function()
		n(msg, level, {
			title = self.title or "[Nvim]",
		})
	end, 500)
end

function M:info(args)
	self:log(levels.INFO, args)
end

function M:warn(args)
	self:log(levels.WARN, args)
end

function M:error(args, code)
	if code then
		code = type(code) == "string" and code or tostring(code)
		args = ("E%s: %s"):format(code, args)
	end
	self:log(levels.ERROR, args)
end

function M:confirm(confirm_args)
	local msg = (confirm_args.msg and self.title) and ("%s: %s"):format(self.title, confirm_args.msg)
		or confirm_args.msg
		or "Confirm"

	return vim.fn.confirm(
		msg,
		confirm_args.choices or "&Yes\n&No\n&Cancel",
		confirm_args.default or 1,
		confirm_args.type or "Question"
	)
end

function M:select(items, ui_opts, on_choice)
	local Util = require("util")
	items = Util.table_or_string(items)
	ui_opts = Util.tbl_extend_force({ prompt = ("%s: Choose"):format(self.title) }, ui_opts)

	vim.ui.select(items, ui_opts, on_choice)
end

function M.delay_notify()
	local notifications = {}
	local function temp(...)
		table.insert(notifications, vim.F.pack_len(...))
	end

	local notify = vim.notify
	vim.notify = temp

	local timer = vim.uv.new_timer()
	local check = assert(vim.uv.new_check())

	local replay = function()
		timer:stop()
		check:stop()
		if vim.notify == temp then
			vim.notify = notify
		end
		vim.schedule(function()
			---@diagnostic disable-next-line: no-unknown
			for _, notification in ipairs(notifications) do
				-- vim.notify(vim.F.unpack_len(notification))
				M:info(vim.F.unpack_len(notification))
			end
		end)
	end

	check:start(function()
		if vim.notify ~= temp then
			replay()
		end
	end)

	timer:start(500, 0, replay)
end

return M
