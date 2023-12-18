local user_command = vim.api.nvim_create_user_command

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

local function edit_macro()
	local register = "q"

	local opts = {
		default = vim.g.edit_macro_last or "",
	}

	if opts.default == "" then
		opts.prompt = "Create Macro"
	else
		opts.prompt = "Edit Macro"
	end

	vim.ui.input(opts, function(input)
		if input == nil then
			return
		end

		local macro = vim.fn.escape(input, '"')
		local command = ('let @%s="%s"'):format(register, macro)

		vim.cmd(command)

		vim.g.edit_macro_last = input
	end)
end

---@param ctx Context
---@param ns number preview namespace id for highlights
---@param buf integer buffer that your preview routine will directly modify to show the previewed results
local function trim_space_preview(ctx, ns, buf)
	vim.cmd.highlight("clear Whitespace")
	local line1 = ctx.line1

	local current_buf = vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(current_buf, line1 - 1, ctx.line2, false)
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
					("%s%s"):format(prefix, line),
				})
				buf_add_highlight(buf, ns, "Substitute", preview_buf_line, #prefix + start_idx - 1, #prefix + end_idx)
				preview_buf_line = preview_buf_line + 1
			end
		end
	end

	return 2
end

---@param ctx Context
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

local function scratch()
	vim.cmd("belowright 10new")
	local bufnr = vim.api.nvim_get_current_buf()

	for name, value in pairs({
		filetype = "scratch",
		buftype = "nofile",
		bufhidden = "hide",
		swapfile = false,
		modifiable = true,
	}) do
		vim.api.nvim_set_option_value(name, value, { buf = bufnr })
	end

	require("keymap").nmap("q", Autocmd.easy_quit, { buffer = bufnr })

	vim.schedule(function()
		vim.cmd.startinsert()
	end)
end

vim.api.nvim_create_autocmd({ "User" }, {
	callback = function()
		user_command("ColorMyPencils", color_my_pencils, { desc = "Toggle transparent background" })

		user_command("EditMacro", edit_macro, { desc = "Create/Edit macro in an input" })

		user_command("Scratch", scratch, { desc = "Open a scratch buffer", nargs = 0 })

		user_command("TrimAllTrailingWhitespace", trim_space, {
			desc = "Trim traling whitespace for the whole document",
			range = "%",
		})

		user_command("TrimTrailingWhitespace", trim_space, {
			addr = "lines",
			desc = "Trim trailing whitespace from a range or from the whole document includes preview",
			nargs = "?",
			preview = trim_space_preview,
			range = "%",
		})
	end,

	group = require("autocmd").augroup("Command"),
	pattern = "SetCommand",
})
