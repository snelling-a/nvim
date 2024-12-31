if vim.g.stop_insert_loaded then
	return
end
vim.g.stop_insert_loaded = true

local timer = nil
local enabled = true

local user_cmds = {
	enable = function()
		enabled = true
	end,
	disable = function()
		enabled = false
	end,
	toggle = function()
		enabled = not enabled
	end,
	status = function()
		if enabled then
			vim.notify("StopInsert is active")
		else
			vim.notify("StopInsert is inactive")
		end
	end,
}

local function visible()
	---@module 'blink.cmp'
	local blink = package.loaded["blink.cmp"]
	if blink then
		return require("blink.cmp.completion.windows.menu").win:is_open()
	else
		return require("copilot.suggestion").is_visible()
	end
end

---@return nil
local function force_exit_insert_mode()
	if vim.fn.mode() == "i" and not visible() then
		vim.cmd.stopinsert()

		vim.notify("You were idling in Insert mode.")
	end
end

---@return nil
local function reset_timer()
	if timer then
		timer:stop()
	end
	timer = vim.defer_fn(force_exit_insert_mode, 5000)
end

Config.autocmd.create_autocmd({ "InsertEnter" }, {
	callback = function()
		if not enabled or Config.util.is_filetype_disabled(vim.bo.filetype) then
			return
		end

		reset_timer()
	end,
	group = "StopInsert",
})

vim.on_key(function(_, _)
	if vim.fn.mode() ~= "i" then
		return
	end

	if not enabled then
		return
	end

	if Config.util.is_filetype_disabled(vim.bo.filetype) then
		return
	end

	reset_timer()
end)

vim.api.nvim_create_user_command("StopInsert", function(cmd)
	if user_cmds[cmd.args] then
		user_cmds[cmd.args]()
	end
end, {
	nargs = 1,
	complete = function()
		return vim.tbl_keys(user_cmds)
	end,
})
