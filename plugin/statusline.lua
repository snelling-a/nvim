local File = require("config.ui.statusline.file")
local Highlights = require("config.ui.statusline.highlights")
local Lsp = require("config.ui.statusline.lsp")
local Statusline = require("config.ui.statusline")

local api = vim.api

local F = setmetatable({}, {
	__index = function(_, name)
		return function(active, mods)
			active = active or false
			mods = mods or ""
			return "%" .. mods .. "{%v:lua.statusline." .. name .. "(v:" .. tostring(active) .. ")%}"
		end
	end,
})

local M = {}

M.git_status = require("config.ui.statusline.git").status
M.lsp_status = Lsp.status
M.bufname = require("config.ui.statusline.buffer").name
M.filetype = File.type
M.encoding = File.encoding
M.ruler = require("config.ui.statusline.ruler").get_ruler

local function set(active, global)
	local scope = global and "o" or "wo"
	vim[scope].statusline = Statusline.parse_sections({
		{
			Statusline.recording(),
			Statusline.pad(F.git_status(active)),
			Statusline.pad(F.lsp_status(active)),
			Statusline.highlight(active),
		},
		{
			"%<",
			Statusline.pad(F.bufname(nil, "0.80") .. "%m%r%h%q"),
		},
		{
			Statusline.pad(F.filetype(active)),
			Statusline.pad(F.encoding()),
			Statusline.pad(F.ruler(active)),
		},
	})
end

-- Only set up WinEnter autocmd when the WinLeave autocmd runs
local group = api.nvim_create_augroup("statusline", {})
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
			callback = function() set(true) end,
		})
	end,
})

api.nvim_create_autocmd({
	"WinLeave",
	"FocusLost",
}, {
	group = group,
	callback = function() set(false) end,
})

api.nvim_create_autocmd({
	"BufAdd",
	"SessionLoadPost",
	"VimEnter",
}, {
	group = group,
	callback = function() set(true, true) end,
})

api.nvim_create_autocmd({
	"ColorScheme",
}, {
	group = group,
	callback = Highlights.defintions,
})

Highlights.defintions()

_G.statusline = M

return M
