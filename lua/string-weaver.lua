local M = {}

local brace_pattern = "%${.-}"
local lua_hex_pattern = "%%06[Xx]"
local lua_placeholder_pattern = "%%[sq]"
local lua_string_mod_pattern = "%%s[*+-]"
local newline_or_cr = "[\n\r]"
local remove_format_pattern = "%((.*)%):format%(.*%)"

---@diagnostic disable-next-line: param-type-mismatch
local can_undojoin = pcall(vim.cmd, "undojoin")

---@param node TSNode
---@param replacement string
local function replace_node_text(node, replacement)
	local start_row, start_column, end_row, end_column = node:range()
	local lines = vim.split(replacement, "\n")
	if can_undojoin then
		vim.cmd.undojoin()
	end
	vim.api.nvim_buf_set_text(0, start_row, start_column, end_row, end_column, lines)
end

local MAX_CHARACTERS = 200

local function template_string()
	local node = vim.treesitter.get_node()
	if not node then
		return
	end

	---@type TSNode|string
	local node_type = node:type()
	if node_type == "string_fragment" or node_type == "escape_sequence" then
		node = node:parent()
		if not node then
			return
		end
		node_type = node:type()
	end

	if node_type ~= "string" and node_type ~= "template_string" then
		return
	end

	local text = vim.treesitter.get_node_text(node, 0)
	if text == "" or #text > MAX_CHARACTERS then
		return
	end

	local is_template = text:sub(1, 1) == "`" and text:sub(-1) == "`"
	local parent_type = node:parent() and node:parent():type()
	local is_tagged_template = parent_type == "call_expression"
	local has_braces = text:find(brace_pattern)
	local is_multiline = text:find(newline_or_cr)

	if not is_template and (has_braces or is_multiline) then
		text = "`" .. text:sub(2, -2) .. "`"
		replace_node_text(node, text)
	elseif is_template and not (has_braces or is_multiline or is_tagged_template) then
		local quote = '"'
		text = quote .. text:sub(2, -2) .. quote
		replace_node_text(node, text)
	end
end

local function lua_format_string()
	local node = vim.treesitter.get_node()
	if not node then
		return
	end

	local node_type = node:type()
	---@type TSNode|nil
	local string_node
	if node_type == "string" then
		string_node = node
	elseif node_type:find("string_content") then
		string_node = node:parent()
	elseif node_type == "escape_sequence" then
		string_node = node:parent() and node:parent():parent()
	end
	if not string_node then
		return
	end

	local text = vim.treesitter.get_node_text(string_node, 0)
	if text == "" or #text > MAX_CHARACTERS then
		return
	end

	local parent = string_node:parent()
	local method_node = parent and parent:prev_sibling() and parent:prev_sibling():child(2)
	if method_node then
		local method_text = vim.treesitter.get_node_text(method_node, 0)
		if vim.tbl_contains({ "match", "gmatch", "find", "gsub" }, method_text) then
			return
		end
	end

	if text:find("%%[waudglpfb]") or text:find(lua_string_mod_pattern) then
		return
	end

	local has_placeholder = (text:find(lua_placeholder_pattern) and not text:find(lua_string_mod_pattern))
		or text:find(lua_hex_pattern)
	local is_format_string = parent and parent:type() == "parenthesized_expression"

	if has_placeholder and not is_format_string then
		replace_node_text(string_node, "(" .. text .. "):format()")
		local row, col = string_node:end_()
		vim.api.nvim_win_set_cursor(0, { row + 1, col - 1 })
		vim.cmd.startinsert()
	elseif is_format_string and not has_placeholder then
		local formatCall = parent and parent:parent() and parent:parent():parent()
		if not formatCall then
			return
		end
		local removed_format = vim.treesitter.get_node_text(formatCall, 0):gsub(remove_format_pattern, "%1")
		replace_node_text(formatCall, removed_format)
	end
end

M.supported_filetypes = {
	astro = template_string,
	javascript = template_string,
	javascriptreact = template_string,
	lua = lua_format_string,
	svelte = template_string,
	typescript = template_string,
	typescriptreact = template_string,
	vue = template_string,
}

---@param ft string
---@return fun()|nil
function M.get_string_transform_function(ft)
	return M.supported_filetypes[ft]
end

---@param mode "Enabled"|"Disabled"
function M.notify(mode)
	vim.schedule(function()
		vim.notify(("StringWeaver %s for current buffer."):format(mode))
	end)
end

return M
