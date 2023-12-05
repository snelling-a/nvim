local File = require("ui.status.line.file")
local Highlights = require("ui.status.line.highlights")
local Lsp = require("ui.status.line.lsp")
local Util = require("ui.status.line.util")

if not require("util").is_vim() then
	return {}
end

local api = vim.api

local F = setmetatable({}, {
	__index = function(_, section)
		---@param active boolean
		---@param mods string
		return function(active, mods)
			active = active or false
			mods = mods or ""
			return ("%%%s{%%v:lua.statusline.%s(v:%s)%%}"):format(mods, section, tostring(active))
		end
	end,
})

local M = {}

M.git_status = require("ui.status.line.git").status
M.lsp_status = Lsp.status
M.buffer_name = require("ui.status.line.buffer").name
M.filetype = File.type
M.encoding = File.encoding
M.ruler = require("ui.status.line.ruler").get_ruler

local function set(active, global)
	local scope = global and "o" or "wo"
	local buffer_name = ("%s%%m%%r%%h%%q"):format(F.buffer_name(nil, "0.80"))

	vim[scope].statusline = Util.parse_sections({
		{
			Util.recording(active),
			Util.highlight(),
			Util.pad(F.git_status(active)),
			Util.pad(F.lsp_status(active)),
			Util.highlight(),
		},
		{
			"%<",
			Util.pad(buffer_name),
		},
		{
			Util.highlight(),
			Util.pad(F.filetype(active)),
			Util.pad(F.encoding()),
			-- Util.pad(F.ruler(active)),
			F.ruler(active),
		},
	})
end

--- Only set up WinEnter autocmd when the WinLeave autocmd runs
local group = require("autocmd").augroup("Statusline")
api.nvim_create_autocmd({
	"FocusLost",
	"RecordingLeave",
	"WinLeave",
}, {
	group = group,
	once = true,
	callback = function()
		api.nvim_create_autocmd({
			"BufEnter",
			"FocusGained",
			"RecordingEnter",
			"WinEnter",
		}, {
			group = group,
			callback = function()
				set(true)
			end,
		})
	end,
})

api.nvim_create_autocmd({
	"WinLeave",
	"FocusLost",
}, {
	group = group,
	callback = function()
		set(false)
	end,
})

api.nvim_create_autocmd({
	"BufAdd",
	"SessionLoadPost",
	"VimEnter",
}, {
	group = group,
	callback = function()
		set(true, true)
	end,
})

api.nvim_create_autocmd({
	"ColorScheme",
}, {
	group = group,
	callback = Highlights.defintions,
})

Highlights.defintions()

return M
