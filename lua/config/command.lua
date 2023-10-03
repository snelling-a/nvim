local Util = require("config.util")

local user_command = vim.api.nvim_create_user_command

--- Create a user command when the command is called
--- see |CmdUndefined|
--- @param name string name of the command
--- @param command fun(ctx?: Context)
--- @param desc string description passed to |vim.api.nvim_create_autocmd| and |vim.api.nvim_create_user_command|
--- @param opts? table opts for |vim.api.nvim_create_user_command|
--- @param once? boolean
local function define_and_call_user_command(name, command, desc, opts, once)
	opts = Util.tbl_extend_force(opts or {}, {
		desc = desc,
	})

	vim.api.nvim_create_autocmd({
		"CmdUndefined",
	}, {
		callback = function() user_command(name, command, opts) end,
		desc = desc,
		group = Util.augroup(name),
		pattern = {
			name,
		},
		once = once,
	})
end

--- @param ctx Context
local function spell_check(ctx)
	local target = #ctx.fargs > 0 and table.concat(ctx.fargs) or "**"

	if target == "%" then
		target = vim.fn.expand(target) --[[@as string]]
	end

	os.execute("cspell --unique --words-only --gitignore " .. target .. " | sort > z_spell.txt")
end

define_and_call_user_command("SpellCheck", spell_check, "Check spelling", {
	complete = function()
		return {
			"**",
			"%",
		}
	end,
	desc = "Check spelling",
	nargs = "?",
})

local function color_my_pencils()
	local get_hl = vim.api.nvim_get_hl
	local set_hl = vim.api.nvim_set_hl
	local normal = get_hl(0, {
		name = "Normal",
	})
	local normal_float = get_hl(0, {
		name = "NormalFloat",
	})

	if vim.tbl_get(normal_float, "bg") or vim.tbl_get(normal, "bg") then
		set_hl(0, "Normal", {
			bg = "none",
		})
		set_hl(0, "NormalFloat", {
			bg = "none",
		})
	else
		vim.cmd.colorscheme(vim.g.colors_name)
	end
end

define_and_call_user_command("ColorMyPencils", color_my_pencils, "Toggle transparent background")

--- @param ctx Context
local function generate_average_color(ctx)
	require("config.ui.average-colorscheme")

	local path = ("%s/colors/average_dark.lua"):format(vim.fn.stdpath("config"), "colors/average_dark.lua")
	local command = ("stylua %s"):format(path)

	os.execute(command)

	if ctx.fargs[1] == "true" then
		vim.cmd.colorscheme("average_dark")
	end
end

user_command("GenerateAverageColor", generate_average_color, {
	desc = "Generate Average Dark Colorscheme",
	complete = function()
		return {
			true,
			false,
		}
	end,
	nargs = "?",
})

--- @param opts Opts
--- @param ns number preview namespace id for highlights
--- @param buf integer buffer that your preview routine will directly modify to show the previewed results
local function trim_space_preview(opts, ns, buf)
	vim.cmd.hi("clear Whitespace")
	local line1 = opts.line1
	local line2 = opts.line2 --[[@as number]]

	local current_buf = vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(current_buf, line1 - 1, line2, false)
	local preview_buf_line = 0
	local buf_add_highlight = vim.api.nvim_buf_add_highlight

	for i, line in ipairs(lines) do
		local start_idx, end_idx = string.find(line, "%s+$")
		if start_idx then
			-- Highlight the match
			buf_add_highlight(current_buf, ns, "Substitute", line1 + i - 2, start_idx - 1, end_idx or 0)
			-- Add lines and set highlights in the preview buffer if inccommand=split
			if buf then
				local prefix = ("|%d| "):format(line1 + i - 1)
				vim.api.nvim_buf_set_lines(buf, preview_buf_line, preview_buf_line, false, {
					prefix .. line,
				})
				buf_add_highlight(buf, ns, "Substitute", preview_buf_line, #prefix + start_idx - 1, #prefix + end_idx)
				preview_buf_line = preview_buf_line + 1
			end
		end
	end

	return 2
end

--- @param ctx Context
local function trim_space(ctx)
	local line1 = ctx.line1
	local line2 = ctx.line2 --[[@as number]]
	local buf = vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(buf, line1 - 1, line2, false)
	local new_lines = {}

	for i, line in ipairs(lines) do
		new_lines[i] = string.gsub(line, "%s+$", "")
	end

	vim.api.nvim_buf_set_lines(buf, line1 - 1, line2, false, new_lines)
end

user_command("TrimAllTrailingWhitespace", trim_space, {
	desc = "Strip whitespace from the end of the line",
	range = "%",
})

user_command("TrimTrailingWhitespace", trim_space, {
	addr = "lines",
	nargs = "?",
	preview = trim_space_preview,
	range = "%",
})
