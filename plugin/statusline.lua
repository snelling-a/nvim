local File = require("config.ui.statusline.file")
local Git = require("config.ui.statusline.git")
local Lsp = require("config.ui.statusline.lsp")
local Statusline = require("config.ui.statusline")

local api = vim.api

local function hldefs()
	Lsp.hl_definitions()

	local fg = Statusline.get_hl("MoreMsg").fg
	api.nvim_set_hl(0, "StatusTS", { fg = fg, bg = Statusline.bg })
end

local F = setmetatable({}, {
	__index = function(_, name)
		return function(active, mods)
			active = active or 1
			mods = mods or ""
			return "%" .. mods .. "{%v:lua.statusline." .. name .. "(" .. tostring(active) .. ")%}"
		end
	end,
})

local M = {}

M.lsp_status = Lsp.status

M.git_status = Git.status

M.filetype = File.type

M.encoding = File.encoding

M.bufname = require("config.ui.statusline.buffer").name

local function set(active, global)
	local scope = global and "o" or "wo"
	vim[scope].statusline = Statusline.parse_sections({
		{
			Statusline.highlight(1, active),
			Statusline.recording(),
			Statusline.pad(F.git_status()),
			Statusline.highlight(2, active),
			Statusline.pad(F.lsp_status(active)),
			Statusline.highlight(3, active),
		},
		{
			"%<",
			Statusline.pad(F.bufname(nil, "0.60") .. "%m%r%h%q"),
		},
		{
			Statusline.pad(F.filetype(active)),
			Statusline.pad(F.encoding()),
			Statusline.highlight(2, active),
			" %3p%% %2l[%02c]/%-3L ", -- 80% 65[12]/120
		},
	})
end

-- Only set up WinEnter autocmd when the WinLeave autocmd runs
local group = api.nvim_create_augroup("statusline", {})
api.nvim_create_autocmd({ "WinLeave", "FocusLost", "RecordingLeave" }, {
	group = group,
	once = true,
	callback = function()
		api.nvim_create_autocmd({ "BufWinEnter", "WinEnter", "FocusGained", "RecordingEnter" }, {
			group = group,
			callback = function() set(1) end,
		})
	end,
})

api.nvim_create_autocmd({ "WinLeave", "FocusLost" }, {
	group = group,
	callback = function() set(0) end,
})

api.nvim_create_autocmd("VimEnter", {
	group = group,
	callback = function() set(1, true) end,
})

api.nvim_create_autocmd("ColorScheme", {
	group = group,
	callback = hldefs,
})
hldefs()

_G.statusline = M

return M
