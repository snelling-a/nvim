local icons = require("config.ui.icons")
local Statusbar = {}

local global_theme = vim.g.theme

Statusbar.theme = {
	bg = global_theme.base01,
	black = global_theme.base00,
	cyan = global_theme.base0C,
	fg = global_theme.base04,
	green = global_theme.base0B,
	magenta = global_theme.base0E,
	oceanblue = global_theme.base0D,
	orange = global_theme.base09,
	red = global_theme.base08,
	skyblue = global_theme.base0D,
	violet = global_theme.base0E,
	white = global_theme.base05,
	yellow = global_theme.base0A,
}

Statusbar.vi_mode_colors = {
	BLOCK = "magenta",
	COMMAND = "red",
	ENTER = "cyan",
	INSERT = "green",
	LINES = "magenta",
	MORE = "cyan",
	NONE = "fg",
	NORMAL = "skyblue",
	OP = "yellow",
	REPLACE = "orange",
	SELECT = "yellow",
	SHELL = "red",
	TERM = "red",
	VISUAL = "magenta",
	["V-REPLACE"] = "orange",
}

local function get_vi_mode() return require("feline.providers.vi_mode").get_mode_color() end

local vim_mode = {
	hl = function() return { fg = "bg", bg = get_vi_mode(), style = "bold", name = "NeovimModeHLColor" } end,
	left_sep = "block",
	provider = function() return vim.api.nvim_get_mode().mode:upper() end,
	right_sep = "block",
}

local diagnostic_errors = { hl = { fg = "red" }, provider = "diagnostic_errors" }
local diagnostic_hints = { hl = { fg = "cyan" }, provider = "diagnostic_hints" }
local diagnostic_info = { hl = { fg = "skyblue" }, provider = "diagnostic_info" }
local diagnostic_warnings = { hl = { fg = "magenta" }, provider = "diagnostic_warnings" }

local lsp = {
	provider = function()
		if not rawget(vim, "lsp") then
			return ""
		end
		if vim.o.columns < 100 then
			return ""
		end
		local progress = vim.lsp.util.get_progress_messages()[1]
		local clients = vim.lsp.get_active_clients({ bufnr = 0 })
		if #clients ~= 0 then
			if progress then
				return icons.misc.gears
			else
				return string.format(
					"%s %s%s",
					icons.progress.done,
					clients[1].name,
					vim.g.autoloaded_copilot_agent == 1 and " " .. icons.kind_icons.Copilot or ""
				)
			end
		end
		return ""
	end,
	hl = function()
		local progress = vim.lsp.util.get_progress_messages()[1]
		return { fg = progress and "yellow" or "fg" }
	end,
}

local macro_recording = {
	provider = function()
		local recording_register = vim.fn.reg_recording()
		if recording_register == "" then
			return ""
		else
			return "recording @" .. recording_register
		end
	end,
	hl = { fg = "orange" },
}

local search_count = { provider = { name = "search_count" } }

local git_add = { hl = { fg = "green" }, provider = "git_diff_added" }
local git_branch = { hl = { fg = "magenta", style = "bold" }, provider = "git_branch" }
local git_diff_changed = { provider = "git_diff_changed" }
local git_diff_removed = { hl = { fg = "red" }, provider = "git_diff_removed" }

local function get_position()
	return math.floor(vim.api.nvim_win_get_cursor(0)[1] / vim.api.nvim_buf_line_count(0) * 100)
end

local progress = {
	provider = function()
		local pos
		local position = get_position()
		if position <= 5 then
			pos = icons.location.top .. "TOP"
		elseif position >= 95 then
			pos = icons.location.bottom .. "BOT"
		else
			pos = position .. icons.misc.percent
		end

		local line, col = vim.fn.line("."), vim.fn.virtcol(".")

		return string.format("%s%d%s%d %s", icons.location.line, line, icons.location.col, col, pos)
	end,
	hl = function()
		local position = get_position()
		local fg, style
		if position <= 5 then
			fg = "skyblue"
			style = "bold"
		elseif position >= 95 then
			fg = "red"
			style = "bold"
		else
			fg = get_vi_mode()
			style = nil
		end
		return { fg = fg, style = style }
	end,
	left_sep = "block",
	right_sep = "block",
}

local gap = { provider = " " }

local left = {
	vim_mode,
	gap,
	diagnostic_errors,
	diagnostic_warnings,
	diagnostic_info,
	diagnostic_hints,
	gap,
	lsp,
}

local middle = { macro_recording }
local right = { search_count, gap, git_branch, git_add, git_diff_removed, git_diff_changed, progress }

-- TODO: add something for inactive buffers
Statusbar.components = { active = { left, middle, right }, inactive = { {}, {}, {} } }

return Statusbar
