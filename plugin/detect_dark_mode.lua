if vim.g.vscode or vim.g.detect_default_dark_loaded then
	return
end
vim.g.detect_default_dark_loaded = true

---@type number
local timer_id
---@type boolean
local is_currently_dark_mode

---@param background "light" | "dark"'
local function set_background(background)
	vim.api.nvim_set_option_value("background", background, {})
end

---@type table
local query_command
---@type "Linux" | "Darwin" | "Windows_NT" | "WSL"
local system

-- Parses the query response for each system
---@param res table
---@return boolean
local function parse_query_response(res)
	if system == "Darwin" then
		return res[1] == "Dark"
	end
	return false
end

---@param cmd table
---@param opts {input?: string, on_stdout?: function, on_exit?: function}
---@return number | 'the job id'
local function start_job(cmd, opts)
	opts = opts or {}
	local id = vim.fn.jobstart(cmd, {
		stdout_buffered = true,
		on_stdout = function(_, data, _)
			if data and opts.on_stdout then
				opts.on_stdout(data)
			end
		end,
		on_exit = function(_, data, _)
			if opts.on_exit then
				opts.on_exit(data)
			end
		end,
	})

	if opts.input then
		vim.fn.chansend(id, opts.input)
		vim.fn.chanclose(id, "stdin")
	end

	return id
end

---@param callback fun(is_dark_mode: boolean)
local function check_is_dark_mode(callback)
	start_job(query_command, {
		on_stdout = function(data)
			local is_dark_mode = parse_query_response(data)
			callback(is_dark_mode)
		end,
	})
end

---@param is_dark_mode boolean
local function change_theme_if_needed(is_dark_mode)
	if is_dark_mode == is_currently_dark_mode then
		return
	end

	is_currently_dark_mode = is_dark_mode
	if is_currently_dark_mode then
		set_background("dark")
	else
		set_background("light")
	end
end

local function start_check_timer()
	timer_id = vim.fn.timer_start(3000, function()
		check_is_dark_mode(change_theme_if_needed)
	end, { ["repeat"] = -1 })
end

if vim.loop.os_uname().release:match("WSL") then
	system = "WSL"
else
	system = vim.loop.os_uname().sysname
end

if system == "Darwin" then
	query_command = { "defaults", "read", "-g", "AppleInterfaceStyle" }
else
	vim.notify("System not supported\nYou should do something about that", vim.log.levels.WARN)
	return
end

if vim.fn.has("unix") ~= 0 then
	if vim.loop.getuid() == 0 then
		---@type string
		local sudo_user = vim.env.SUDO_USER

		if sudo_user ~= nil then
			query_command = vim.tbl_extend("keep", { "su", "-", sudo_user, "-c" }, query_command)
		else
			error("Running as `root`, but `$SUDO_USER` is not set.")
		end
	end
end

check_is_dark_mode(change_theme_if_needed)
start_check_timer()

local function disable()
	vim.fn.timer_stop(timer_id)
end

return { disable = disable }
