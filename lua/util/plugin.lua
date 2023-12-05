local augroup = require("autocmd").augroup

---@class util.plugin
local M = {}

local USE_FILE_LOADED = true
local file_loaded_events = {
	"BufReadPost",
	"BufNewFile",
	"BufWritePre",
}

local id = "FileLoaded"
local group = augroup(id)
function M.setup()
	USE_FILE_LOADED = USE_FILE_LOADED and vim.fn.argc(-1) > 0

	local Event = require("lazy.core.handler.event")

	if USE_FILE_LOADED then
		Event.mappings.FileLoaded = {
			id = id,
			event = "User",
			pattern = id,
		}
		Event.mappings["User FileLoaded"] = Event.mappings.FileLoaded
	else
		Event.mappings.FileLoaded = {
			id = id,
			event = {
				"BufReadPost",
				"BufNewFile",
				"BufWritePre",
			},
		}
		Event.mappings["User FileLoaded"] = Event.mappings.FileLoaded
		return
	end

	---@type {event: string, buf: number, data?: any}[]
	local events = {}
	local done = false

	local function load()
		if #events == 0 or done then
			return
		end
		done = true

		vim.api.nvim_del_augroup_by_id(group)

		---@type table<string,string[]>
		local skips = {}
		for _, event in ipairs(events) do
			skips[event.event] = skips[event.event] or Event.get_augroups(event.event)
		end

		vim.api.nvim_exec_autocmds("User", {
			pattern = id,
			modeline = false,
		})

		for _, event in ipairs(events) do
			if vim.api.nvim_buf_is_valid(event.buf) then
				Event.trigger({
					event = event.event,
					exclude = skips[event.event],
					data = event.data,
					buf = event.buf,
				})
				if vim.bo[event.buf].filetype then
					Event.trigger({
						event = "FileType",
						buf = event.buf,
					})
				end
			end
		end
		vim.api.nvim_exec_autocmds("CursorMoved", {
			modeline = false,
		})
		events = {}
	end

	load = vim.schedule_wrap(load)

	vim.api.nvim_create_autocmd(file_loaded_events, {
		---@param ev Ev
		callback = function(ev)
			table.insert(events, ev)
			load()
		end,
		group = group,
	})
end

return M
