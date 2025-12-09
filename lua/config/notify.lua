local M = {}

local notifications = {}
local lsp_progress = {}
local win = nil
local buf = nil
local timer = nil
local ns = vim.api.nvim_create_namespace("notify")

local DISPLAY_MS = 3000
local FADE_MS = 500
local MAX_WIDTH = 50
local MAX_LINES = 10
local PADDING = { right = 2, bottom = 1 }
local SPINNER = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
local SPINNER_MS = 80

local icons = {
	[vim.log.levels.ERROR] = " ",
	[vim.log.levels.WARN] = " ",
	[vim.log.levels.INFO] = " ",
	[vim.log.levels.DEBUG] = " ",
	[vim.log.levels.TRACE] = " ",
}

local hls = {
	[vim.log.levels.ERROR] = "DiagnosticError",
	[vim.log.levels.WARN] = "DiagnosticWarn",
	[vim.log.levels.INFO] = "DiagnosticInfo",
	[vim.log.levels.DEBUG] = "DiagnosticHint",
	[vim.log.levels.TRACE] = "Comment",
}

local function close_window()
	if win and vim.api.nvim_win_is_valid(win) then
		vim.api.nvim_win_close(win, true)
	end
	if buf and vim.api.nvim_buf_is_valid(buf) then
		vim.api.nvim_buf_delete(buf, { force = true })
	end
	win = nil
	buf = nil
end

local spinner_idx = 1

local function render()
	local has_progress = not vim.tbl_isempty(lsp_progress)
	if #notifications == 0 and not has_progress then
		close_window()
		return
	end

	local lines = {}
	local highlights = {}

	for _, client_progress in pairs(lsp_progress) do
		local spinner = SPINNER[spinner_idx]
		local line = spinner .. " " .. client_progress.name .. ": " .. (client_progress.msg or "")
		if #line > MAX_WIDTH then
			line = line:sub(1, MAX_WIDTH - 1) .. "…"
		end
		lines[#lines + 1] = line
		highlights[#highlights + 1] = { hl = "DiagnosticInfo", col = 0, end_col = #spinner }
	end

	for _, notif in ipairs(notifications) do
		local icon = icons[notif.level] or icons[vim.log.levels.INFO]
		local hl = hls[notif.level] or hls[vim.log.levels.INFO]
		local line = icon .. notif.msg
		if #line > MAX_WIDTH then
			line = line:sub(1, MAX_WIDTH - 1) .. "…"
		end
		lines[#lines + 1] = line
		highlights[#highlights + 1] = { hl = hl, col = 0, end_col = #icon }
	end

	if #lines > MAX_LINES then
		lines = vim.list_slice(lines, #lines - MAX_LINES + 1)
		highlights = vim.list_slice(highlights, #highlights - MAX_LINES + 1)
	end

	local width = 0
	for _, line in ipairs(lines) do
		width = math.max(width, vim.api.nvim_strwidth(line))
	end

	if not buf or not vim.api.nvim_buf_is_valid(buf) then
		buf = vim.api.nvim_create_buf(false, true)
		vim.bo[buf].bufhidden = "wipe"
	end

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

	for i, h in ipairs(highlights) do
		vim.api.nvim_buf_set_extmark(buf, ns, i - 1, h.col, {
			end_col = h.end_col,
			hl_group = h.hl,
		})
	end

	local row = vim.o.lines - vim.o.cmdheight - #lines - PADDING.bottom
	local col = vim.o.columns - width - PADDING.right

	local opts = {
		relative = "editor",
		row = row,
		col = col,
		width = width,
		height = #lines,
		style = "minimal",
		border = "none",
		focusable = false,
		noautocmd = true,
		zindex = 50,
	}

	if win and vim.api.nvim_win_is_valid(win) then
		vim.api.nvim_win_set_config(win, opts)
	else
		win = vim.api.nvim_open_win(buf, false, opts)
		vim.wo[win].winblend = 100
	end
end

local function schedule_cleanup()
	if timer then
		timer:stop()
	else
		timer = vim.uv.new_timer()
	end

	timer:start(DISPLAY_MS, FADE_MS, function()
		vim.schedule(function()
			if #notifications > 0 then
				table.remove(notifications, 1)
				render()
			end
			if #notifications == 0 and timer then
				timer:stop()
			end
		end)
	end)
end

function M.notify(msg, level, _opts)
	if not msg or msg == "" then
		return
	end

	level = level or vim.log.levels.INFO

	msg = msg:gsub("\n", " ")

	table.insert(notifications, {
		msg = msg,
		level = level,
		time = vim.uv.now(),
	})

	render()
	schedule_cleanup()
end

local spinner_timer = nil

local function start_spinner()
	if spinner_timer then
		return
	end
	spinner_timer = vim.uv.new_timer()
	spinner_timer:start(0, SPINNER_MS, function()
		vim.schedule(function()
			spinner_idx = spinner_idx % #SPINNER + 1
			if not vim.tbl_isempty(lsp_progress) then
				render()
			else
				if spinner_timer then
					spinner_timer:stop()
					spinner_timer:close()
					spinner_timer = nil
				end
			end
		end)
	end)
end

local function on_progress(ev)
	local client = vim.lsp.get_client_by_id(ev.data.client_id)
	if not client then
		return
	end

	local value = ev.data.params.value
	local key = ev.data.client_id

	if value.kind == "end" then
		lsp_progress[key] = nil
		if vim.tbl_isempty(lsp_progress) then
			render()
		end
		return
	end

	local msg = value.title or ""
	if value.message then
		msg = msg .. " " .. value.message
	end
	if value.percentage then
		msg = msg .. " (" .. value.percentage .. "%%)"
	end

	lsp_progress[key] = { name = client.name, msg = msg }
	start_spinner()
end

-- Keep history of all notifications
local history = {}
local MAX_HISTORY = 100

local original_notify = M.notify
function M.notify(msg, level, opts)
	if msg and msg ~= "" then
		table.insert(history, {
			msg = msg,
			level = level or vim.log.levels.INFO,
			time = os.date("%H:%M:%S"),
		})
		if #history > MAX_HISTORY then
			table.remove(history, 1)
		end
	end
	return original_notify(msg, level, opts)
end

function M.history()
	if #history == 0 then
		print("No notification history")
		return
	end
	for _, item in ipairs(history) do
		local level_name = ({ "DEBUG", "ERROR", "INFO", "TRACE", "WARN" })[item.level] or "INFO"
		print(("[%s] [%s] %s"):format(item.time, level_name, item.msg))
	end
end

function M.setup()
	vim.notify = M.notify
	vim.api.nvim_create_autocmd("LspProgress", {
		callback = on_progress,
		desc = "LSP progress handler",
	})
	vim.api.nvim_create_user_command("NotifyHistory", M.history, { desc = "Show notification history" })
end

return M
