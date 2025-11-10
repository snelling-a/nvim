local M = {}

-- Compute the mirrored undo file path
---@param filepath string
---@return string
local function get_undo_file(filepath)
	local undofile = vim.fn.fnamemodify(filepath, ":p") -- absolute path
	undofile = undofile:gsub("%%", "/")
	undofile = undofile:gsub("//+", "/")
	local base = vim.fn.stdpath("data") .. "/undo_tree"
	return base .. undofile .. ".undo"
end

-- Write undo file
function M.write_undo()
	local filepath = vim.fn.expand("%:p")
	if filepath == "" then
		return
	end
	local undofile = get_undo_file(filepath)
	local undodir = vim.fn.fnamemodify(undofile, ":h")
	if vim.uv.fs_stat(undodir) == nil then
		vim.fn.mkdir(undodir, "p")
	end
	vim.cmd("silent wundo " .. vim.fn.fnameescape(undofile))
end

-- Read undo file
function M.read_undo()
	local filepath = vim.fn.expand("%:p")
	if filepath == "" then
		return
	end
	local undofile = get_undo_file(filepath)
	if vim.fn.filereadable(undofile) == 1 then
		vim.cmd("silent rundo " .. vim.fn.fnameescape(undofile))
	end
end

return M
