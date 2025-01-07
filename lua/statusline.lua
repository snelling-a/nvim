---@param name string Highlight group name, e.g. "ErrorMsg"
---@param val vim.api.keyset.highlight Highlight definition map
local function set_hl(name, val)
	vim.api.nvim_set_hl(0, "Statusline" .. name, val)
end

---@param name string Get a highlight definition by name.
---@return vim.api.keyset.get_hl_info highlight group options
local function get_hl(name)
	return vim.api.nvim_get_hl(0, { name = name, link = false })
end

local function setup_colors()
	local fg_color = get_hl("CursorLineNr").fg
	local bg_color = get_hl("Statusline").bg

	set_hl("ConfirmAccent", { fg = fg_color, bold = true, bg = get_hl("WarningMsg").fg })
	set_hl("InsertAccent", { fg = fg_color, bold = true, bg = get_hl("String").fg })
	set_hl("MiscAccent", { fg = fg_color, bold = true, bg = get_hl("StatusLineNC").fg })
	set_hl("NormalAccent", { fg = fg_color, bold = true, bg = get_hl("Title").fg })
	set_hl("ReplaceAccent", { fg = fg_color, bold = true, bg = get_hl("Changed").fg })
	set_hl("TerminalAccent", { fg = fg_color, bold = true, bg = get_hl("MoreMsg").fg })
	set_hl("VCS", { bg = get_hl("Changed").fg, fg = bg_color })
	set_hl("VisualAccent", { fg = fg_color, bold = true, bg = get_hl("IncSearch").bg })
end

Config.autocmd.create_autocmd({ "ColorScheme" }, {
	callback = setup_colors,
	pattern = "*",
	group = "StatuslineColors",
})
setup_colors()

local function vcs()
	local git_info = vim.b.gitsigns_status_dict
	if (not git_info or not git_info.head) or git_info.head == "" then
		return ""
	end

	local added = git_info.added and ("%#Added#+" .. git_info.added .. " ") or ""
	local modified = git_info.changed and ("%#Changed#~" .. git_info.changed .. " ") or ""
	local removed = git_info.removed and ("%#Removed#-" .. git_info.removed) or ""
	local branch = (git_info.head == "master" or git_info.head == "main") and "" or git_info.head

	return table.concat({
		added,
		modified,
		removed,
		((added ~= "") or (removed ~= "") or (modified ~= "")) and " " or "",
		"%#StatuslineVCS#",
		" ",
		Config.icons.git.branch,
		branch,
		" ",
	})
end

---@return string VimMode statusline component for current mode
local function get_mode_component()
	local mode = vim.api.nvim_get_mode().mode
	local first_char = mode:sub(1, 1)

	---@type string
	local hl
	if first_char == "n" then
		hl = "Normal"
	elseif first_char == "i" then
		hl = "Insert"
	elseif first_char == "R" then
		hl = "Replace"
	elseif first_char == "c" then
		hl = "Confirm"
	elseif mode == "t" then
		hl = "Terminal"
	elseif mode == "v" or mode == "V" or mode == "\22" then
		hl = "Visual"
	else
		hl = "Misc"
	end

	local width = 4
	local icon = Config.icons.misc.neovim
	local padded_icon = icon .. string.rep(" ", width - (#icon + #mode))

	return table.concat({ "%#", "Statusline", hl, "Accent", "#", padded_icon, " ", mode:upper(), " " })
end

local function get_readonly_space()
	local is_readonly = vim.api.nvim_eval_statusline("%r", {}).str == "[RO]"

	if not is_readonly then
		return ""
	end

	local readonly = is_readonly and " " or ""

	return readonly and Config.icons.misc.readonly .. readonly
end

local function get_modified_space()
	local flag = vim.api.nvim_eval_statusline("%m", {}).str
	if flag == "[-]" then
		return ""
	end

	local is_modified = #flag > 0

	if not is_modified then
		return ""
	end

	local modified = is_modified and " " or ""

	return modified and "%#WarningMsg#" .. Config.icons.git.modified .. modified
end

---@param severity vim.diagnostic.Severity See |diagnostic-severity|
---@return integer # Number of diagnostics with the given severity
local function get_diagnostics_count(severity)
	return #vim.diagnostic.get(0, { severity = severity })
end

local function diagnostics()
	local errors = get_diagnostics_count(vim.diagnostic.severity.ERROR)
	local warnings = get_diagnostics_count(vim.diagnostic.severity.WARN)
	local hints = get_diagnostics_count(vim.diagnostic.severity.HINT)
	local info = get_diagnostics_count(vim.diagnostic.severity.INFO)

	---@type string[]
	local components = {}
	if errors > 0 then
		components[#components + 1] = "%#DiagnosticError#" .. Config.icons.diagnostics.Error .. " " .. errors
	end
	if warnings > 0 then
		components[#components + 1] = "%#DiagnosticWarning#" .. Config.icons.diagnostics.Warn .. " " .. warnings
	end
	if hints > 0 then
		components[#components + 1] = "%#DiagnosticHint#" .. Config.icons.diagnostics.Hint .. " " .. hints
	end
	if info > 0 then
		components[#components + 1] = "%#DiagnosticInfo#" .. Config.icons.diagnostics.Info .. " " .. info
	end

	return table.concat(components, " ")
end

local function lsp_servers()
	local icons = {}
	for _, client in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
		local icon = Config.util.get_lsp_icon(client.name)
		table.insert(icons, icon)
	end

	if #icons == 0 then
		return ""
	end

	return "[ " .. table.concat(icons, " ") .. " ]"
end

local function file_type_name()
	local fname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
	local icon, color = Config.util.get_file_icon()
	vim.api.nvim_set_hl(0, "StatuslineFiletype", { fg = color })
	return "%#StatuslineFiletype#" .. icon .. "  %#Statusline#" .. fname
end

---@type table<number, string>
local statuslines = {}

local function get_starter_statusline()
	local fg = get_hl("String").fg
	local bg = get_hl("StatusLineNC").bg
	set_hl("Starter", { fg = fg, bg = bg })

	return table.concat({ "%=", "%#StatuslineStarter#", Config.icons.misc.neovim, " ", "%=" })
end

---@class StatusLine
local M = setmetatable({}, {
	---@param t StatusLine
	---@return string
	__call = function(t)
		return t.get()
	end,
})

function M.get()
	if vim.bo.filetype == "ministarter" then
		return get_starter_statusline()
	end

	setup_colors()
	local win_id = vim.g.statusline_winid
	if win_id == vim.api.nvim_get_current_win() or statuslines[win_id] == nil then
		local ft_name = file_type_name() .. " "
		local lsp_info = lsp_servers()
		local diagnostics_info = diagnostics()

		local whatever = {
			get_mode_component(),
			"%#Statusline#",
			" %l/%L|%c ",
			ft_name,
			"%<%#StatuslineFilenameNoMod#",
			get_readonly_space(),
			get_modified_space(),
			"%#Statusline#",
			#diagnostics_info > 0 and " " .. diagnostics_info or "",
			" ",
			"%=%#Statusline#",
			lsp_info,
			"%=",
			vcs(),
		}

		local stat = table.concat(whatever)
		statuslines[win_id] = stat
	end
	return statuslines[win_id]
end

return M
