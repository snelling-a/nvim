local M = {}

local nodes = {}
local ticks = {}

local function get_nodes(buf)
	local tick = vim.api.nvim_buf_get_changedtick(buf)
	if not nodes[buf] or ticks[buf] ~= tick then
		nodes[buf] = {}
		ticks[buf] = tick
	end
	return nodes[buf]
end

local function get_range(node)
	local srow, scol, erow, ecol = node:range()
	if ecol == 0 then
		erow = erow - 1
		local line = vim.api.nvim_buf_get_lines(0, erow, erow + 1, false)[1]
		ecol = math.max(#line, 1)
	end
	return { srow, scol, erow, ecol - 1 }
end

local function get_visual_range()
	local _, srow, scol = unpack(vim.fn.getpos("."))
	local _, erow, ecol = unpack(vim.fn.getpos("v"))
	srow, scol, erow, ecol = srow - 1, scol - 1, erow - 1, ecol - 1
	if srow < erow or (srow == erow and scol <= ecol) then
		return { srow, scol, erow, ecol }
	end
	return { erow, ecol, srow, scol }
end

local function ranges_equal(a, b)
	return a[1] == b[1] and a[2] == b[2] and a[3] == b[3] and a[4] == b[4]
end

local function select_node(node)
	local range = get_range(node)
	if vim.api.nvim_get_mode().mode ~= "v" then
		vim.cmd.normal({ "v", bang = true })
	end
	vim.api.nvim_win_set_cursor(0, { range[1] + 1, range[2] })
	vim.cmd.normal({ "o", bang = true })
	vim.api.nvim_win_set_cursor(0, { range[3] + 1, range[4] })
end

function M.init()
	local buf = vim.api.nvim_get_current_buf()
	local node = vim.treesitter.get_node({ ignore_injections = false })
	if node then
		local buf_nodes = get_nodes(buf)
		buf_nodes[#buf_nodes + 1] = node
		select_node(node)
	end
end

function M.increment()
	local buf = vim.api.nvim_get_current_buf()
	local buf_nodes = get_nodes(buf)
	local range = get_visual_range()
	local last = buf_nodes[#buf_nodes]

	local node
	if not last or not ranges_equal(range, get_range(last)) then
		local ok, parser = pcall(vim.treesitter.get_parser, buf)
		if not ok or not parser then
			return
		end
		parser:parse()
		node = parser:named_node_for_range({ range[1], range[2], range[3], range[4] + 1 })
		nodes[buf] = {}
		ticks[buf] = vim.api.nvim_buf_get_changedtick(buf)
		buf_nodes = nodes[buf]
	else
		node = last:parent()
		while node and ranges_equal(range, get_range(node)) do
			node = node:parent()
		end
	end

	if node then
		buf_nodes[#buf_nodes + 1] = node
		select_node(node)
	end
end

function M.decrement()
	local buf = vim.api.nvim_get_current_buf()
	local buf_nodes = get_nodes(buf)
	if #buf_nodes > 1 then
		buf_nodes[#buf_nodes] = nil
		select_node(buf_nodes[#buf_nodes])
	end
end

function M.setup()
	vim.keymap.set("n", "<C-Space>", M.init, { desc = "Init treesitter selection" })
	vim.keymap.set("x", "<C-Space>", M.increment, { desc = "Increment selection" })
	vim.keymap.set("x", "<BS>", M.decrement, { desc = "Decrement selection" })
end

return M
