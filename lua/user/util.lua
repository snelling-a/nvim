---@class user.Util
local M = {}

-- capitalize the first letter of a string
---@param str string Input string
---@return string # Input string with the first letter capitalized
function M.capitalize_first_letter(str)
	return str:sub(1, 1):upper() .. str:gsub("^%u(.*)", function(rest)
		return rest:lower()
	end)
end

---@param bufnr integer
function M.easy_quit(bufnr)
	vim.bo[bufnr].buflisted = false
	vim.keymap.set("n", "q", function()
		if M.is_man(bufnr) then
			vim.cmd.quitall()
		end

		xpcall(vim.cmd.close, function()
			vim.cmd.bwipeout()
		end)

		vim.cmd.wincmd("p")
	end, { buffer = bufnr, desc = "Quit Buffer" })
end

-- Get the path to the Node.js executable.
function M.get_node_path()
	local result = vim.fn.system("which node")

	result = result:gsub("\r\n$", ""):gsub("\n$", "")

	if vim.v.shell_error ~= 0 then
		vim.notify("Error: Could not find Node.js path.")
		return nil
	end

	return result
end

---@param bufnr integer
---@return boolean
function M.is_man(bufnr)
	return vim.bo[bufnr].filetype == "man"
end

---@param ft? string file type
---@return boolean Disabled is file type disabled
function M.is_filetype_disabled(ft)
	ft = ft or vim.bo.ft
	for _, value in pairs(DisabledFiletypes) do
		if ft:match(value) then
			return true
		end
	end

	return false
end

return M
