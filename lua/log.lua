local log_filename = vim.fn.stdpath("log") .. "/debug.log"

---@class Log
local M = {}

-- Log a message to the file `vim.fn.stdpath("log")/debug.log`.
-- a timestamp will be added to every message.
function M.log(...)
	local file = io.open(log_filename, "a+")

	if not file then
		error(("Could not open file %q for writing"):format(log_filename))
	end

	local args_number = select("#", ...)
	local parts = {} ---@type string[]

	for i = 1, args_number do
		local v = select(i, ...)
		parts[i] = type(v) == "string" and v or vim.inspect(v)
	end

	local msg = table.concat(parts, " ")
	msg = #msg < 120 and msg:gsub("%s+", " ") or msg

	file:write(("[ %s ] %s"):format(os.date("%Y-%m-%d %H:%M:%S"), msg))
	file:write("\n")
	file:close()
end

local function log_qftf()
	---@type {text:string}[]
	local qf_list = vim.fn.getqflist({ id = 0, items = 0 }).items

	---@type string[]
	local items = {}

	for _, e in ipairs(qf_list) do
		table.insert(items, e.text)
	end

	return items
end

local function jump_to_log_line()
	---@type integer
	local qf_entry = vim.fn.getqflist({ idx = vim.fn.line(".") }).idx
	if qf_entry then
		vim.cmd.wincmd("p")
		vim.cmd.view(log_filename)
		vim.cmd("normal! " .. qf_entry .. "G")
	end
end

function M.read_log()
	local quickfix_entries = {}

	local lnum = 1
	for line in io.lines(log_filename) do
		---@type string, string
		local timestamp, message = line:match("%[(.-)%]%s*(.*)")

		local formatted_text = timestamp and message and (timestamp .. " | " .. message) or line

		table.insert(quickfix_entries, {
			filename = "",
			lnum = 0,
			text = formatted_text,
		})
		lnum = lnum + 1
	end

	vim.fn.setqflist({}, "r", {
		quickfixtextfunc = log_qftf,
		items = quickfix_entries,
		title = "Nvim Log",
		---@diagnostic disable-next-line: assign-type-mismatch
		idx = "$",
	})
	vim.cmd.copen()

	vim.keymap.set("n", "<CR>", jump_to_log_line, { noremap = true, buffer = true })
end

return setmetatable(M, {
	---@param t Log
	---@param ... any
	---@return nil
	__call = function(t, ...)
		return t.log(...)
	end,
})
