local priority = 100
local group_name = "marks"
local augroup = vim.api.nvim_create_augroup("user" .. group_name, { clear = true })

-- Get all marks (global and local) for a buffer.
---@param bufnr number
---@return vim.fn.getmarklist.ret.item[]
local function list_marks(bufnr)
	local marks = vim.fn.getmarklist(bufnr)
	---@param mark vim.fn.getmarklist.ret.item
	---@return boolean
	local global_marks = vim.tbl_filter(function(mark)
		return mark.pos[1] == bufnr
	end, vim.fn.getmarklist())

	return vim.list_extend(marks, global_marks)
end

local function render_mark(bufnr, mark, lnum)
	if not mark:match("[a-zA-Z]") then
		return
	end
	vim.fn.sign_place(mark:byte(), group_name, group_name .. "_" .. mark, bufnr, {
		lnum = lnum,
		priority = priority,
	})
end

local function render_all_marks(bufnr)
	vim.fn.sign_unplace(group_name, { buffer = bufnr })
	for _, mark in ipairs(list_marks(bufnr)) do
		local char = mark.mark:sub(2, 2)
		render_mark(bufnr, char, mark.pos[2])
	end
end

local function delete_mark(mark)
	local bufnr = vim.api.nvim_get_current_buf()
	vim.fn.sign_unplace(group_name, { buffer = bufnr, id = mark:byte() })
	vim.cmd("delmarks " .. mark)
end

local function delete_all_marks()
	local bufnr = vim.api.nvim_get_current_buf()
	vim.fn.sign_unplace(group_name, { buffer = bufnr })
	vim.cmd("delmarks A-Za-z")
end

if vim.version().minor >= 12 then
	vim.api.nvim_set_hl(0, "MarkGutterLower", { link = "DiagnosticSignOk", default = true })
	vim.api.nvim_set_hl(0, "MarkGutterUpper", { link = "DiagnosticSignOk", default = true })

	for _, range in ipairs({ { 65, 90 }, { 97, 122 } }) do
		for i = range[1], range[2] do
			local char = string.char(i)
			vim.fn.sign_define(group_name .. "_" .. char, {
				text = char,
				texthl = char:match("[a-z]") and "MarkGutterLower" or "MarkGutterUpper",
				linehl = "",
				numhl = "",
			})
		end
	end

	vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
		callback = function(event)
			render_all_marks(event.buf)
		end,
		desc = "Render marks in sign column",
		group = augroup,
	})

	vim.api.nvim_create_autocmd({ "MarkSet" }, {
		callback = function(event)
			render_mark(event.buf, event.data.name, event.data.line)
		end,
		desc = "Render mark sign when a mark is set",
		group = augroup,
	})

	vim.keymap.set("n", "dm", function()
		local bufnr = vim.api.nvim_get_current_buf()
		local lnum = vim.api.nvim_win_get_cursor(0)[1]
		for _, mark in ipairs(list_marks(bufnr)) do
			if mark.pos[2] == lnum then
				delete_mark(mark.mark:sub(2, 2))
				return
			end
		end
	end, { desc = "Delete mark on current line" })

	vim.keymap.set("n", "dM", function()
		delete_all_marks()
	end, { desc = "Delete all marks" })
else
	vim.print("Nightly neovim required!")
end
