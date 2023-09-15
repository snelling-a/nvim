local command = vim.api.nvim_create_user_command
local api = vim.api
local cmd = vim.cmd

command("SpellCheck", function(ctx)
	local target = #ctx.fargs > 0 and table.concat(ctx.fargs) or "**"

	if target == "%" then
		--- @diagnostic disable-next-line: cast-local-type
		target = vim.fn.expand(target)
	end

	os.execute("cspell --unique --words-only --gitignore " .. target .. " | sort > z_spell.txt")
end, {
	complete = function()
		return {
			"**",
			"%",
		}
	end,
	desc = "Check spelling",
	nargs = "?",
})

command("ColorMyPencils", function()
	local normal = api.nvim_get_hl(0, {
		name = "Normal",
	})
	local normal_float = api.nvim_get_hl(0, {
		name = "NormalFloat",
	})

	if vim.tbl_get(normal_float, "bg") or vim.tbl_get(normal, "bg") then
		api.nvim_set_hl(0, "Normal", {
			bg = "none",
		})
		api.nvim_set_hl(0, "NormalFloat", {
			bg = "none",
		})
	else
		cmd.colorscheme(vim.g.colors_name)
	end
end, {
	desc = "Toggle transparent background",
})

command("GenerateAverageColor", function()
	require("config.ui.average-colorscheme")

	vim.cmd.colorschem("average_dark")
end, {})

local function trim_space_preview(opts, preview_ns, preview_buf)
	vim.cmd([[hi clear Whitespace]])
	local line1 = opts.line1
	local line2 = opts.line2
	local buf = vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(buf, line1 - 1, line2, false)
	local preview_buf_line = 0
	for i, line in ipairs(lines) do
		local start_idx, end_idx = string.find(line, "%s+$")
		if start_idx then
			-- Highlight the match
			vim.api.nvim_buf_add_highlight(buf, preview_ns, "Substitute", line1 + i - 2, start_idx - 1, end_idx or 0)
			-- Add lines and set highlights in the preview buffer if inccommand=split
			if preview_buf then
				local prefix = string.format("|%d| ", line1 + i - 1)
				vim.api.nvim_buf_set_lines(preview_buf, preview_buf_line, preview_buf_line, false, {
					prefix .. line,
				})
				vim.api.nvim_buf_add_highlight(
					preview_buf,
					preview_ns,
					"Substitute",
					preview_buf_line,
					#prefix + start_idx - 1,
					#prefix + end_idx
				)
				preview_buf_line = preview_buf_line + 1
			end
		end
	end

	return 2
end

local function trim_space(opts)
	local line1 = opts.line1
	local line2 = opts.line2
	local buf = vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(buf, line1 - 1, line2, false)
	local new_lines = {}

	for i, line in ipairs(lines) do
		new_lines[i] = string.gsub(line, "%s+$", "")
	end

	vim.api.nvim_buf_set_lines(buf, line1 - 1, line2, false, new_lines)
end

command("TrimAllTrailingWhitespace", trim_space, {
	desc = "Strip whitespace from the end of the line",
	range = "%",
})

command("TrimTrailingWhitespace", trim_space, {
	addr = "lines",
	nargs = "?",
	preview = trim_space_preview,
	range = "%",
})
