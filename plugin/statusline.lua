local File = require("config.ui.statusline.file")
local Lsp = require("config.ui.statusline.lsp")
local Statusline = require("config.ui.statusline")

local api = vim.api

local function hldefs()
	Lsp.lsp_hldefs()

	local green_fg = Statusline.get_hl("ModeMsg").fg
	api.nvim_set_hl(0, "StatusGreen", {
		fg = green_fg,
		bg = Statusline.bg,
	})

	local red_fg = Statusline.get_hl("ErrorMsg").fg
	api.nvim_set_hl(0, "StatusRed", {
		fg = red_fg,
		bg = Statusline.bg,
	})

	local blue_fg = Statusline.get_hl("Title").fg
	api.nvim_set_hl(0, "StatusBlue", {
		fg = blue_fg,
		bg = Statusline.bg,
	})

	local cyan_fg = Statusline.get_hl("FoldColumn").fg
	api.nvim_set_hl(0, "StatusCyan", {
		fg = cyan_fg,
		bg = Statusline.bg,
	})

	local magenta_fg = Statusline.get_hl("Conditional").fg
	api.nvim_set_hl(0, "StatusMagenta", {
		fg = magenta_fg,
		bg = Statusline.bg,
	})
end

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
			Statusline.pad(F.bufname(nil, "0.60") .. "%m%r%h%q"),
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
			"BufWinEnter",
			"FocusGained",
			"RecordingEnter",
			"WinEnter",
		}, {
			group = group,
			callback = function()
				if vim.bo.filetype == "starter" then
					return ""
				end
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
	callback = function() set(false) end,
})

api.nvim_create_autocmd({
	"BufAdd",
}, {
	group = group,
	callback = function() set(true, true) end,
})

api.nvim_create_autocmd({
	"ColorScheme",
}, {
	group = group,
	callback = hldefs,
})
hldefs()

_G.statusline = M

return M
