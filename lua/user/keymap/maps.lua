---@class user.Keymap.maps
local M = {}

---@type {string:fun():boolean?}[]
local cmp_actions = {
	snippet_forward = function()
		if vim.snippet.active({ direction = 1 }) then
			vim.schedule(function()
				vim.snippet.jump(1)
			end)
			return true
		end
	end,
	copilot_accept = function()
		if require("copilot.suggestion").is_visible() then
			if vim.api.nvim_get_mode().mode == "i" then
				local create_undo = vim.api.nvim_replace_termcodes("<c-G>u", true, true, true)
				M.feedkeys(create_undo, "n", true)
			end
			require("copilot.suggestion").accept()
			return true
		end
	end,
}

---@param actions string[]
---@return fun():boolean|string?
function M.complete(actions)
	return function()
		for _, name in ipairs(actions) do
			if cmp_actions[name] then
				local action = cmp_actions[name]()
				if action then
					return true
				end
			end
		end
	end
end

---@param key ","|"."|";"|")"|"}"|">"|"]" Key to create a break point
function M.create_breakpoint(key)
	vim.keymap.set({ "i" }, key, key .. "<c-g>u", { desc = "Add undoable break point at '" .. key .. "'" })
end

---@param count 1|-1 The number of diagnostics to jump
---@param severity? vim.diagnostic.Severity See |diagnostic-severity|.
---@return fun():vim.Diagnostic?
function M.diagnostic_goto(count, severity)
	return function()
		vim.diagnostic.jump({ count = count, severity = severity })
	end
end

--- wrapper for |nvim_feedkeys| that handles <key> syntax
---@param keys string keys to be typed
---@param mode? string behavior flags, see `feedkeys()`
---@param escape_ks? boolean default: true
---@return nil
function M.feedkeys(keys, mode, escape_ks)
	escape_ks = escape_ks ~= false

	if keys:sub(1, 1) == "<" then
		keys = vim.api.nvim_replace_termcodes(keys, true, false, true)
		escape_ks = false
	end

	return vim.api.nvim_feedkeys(keys, mode or "n", escape_ks)
end

---@param lhs "<"|">" Left-hand side |{lhs}| of the mapping.
function M.indent(lhs)
	vim.keymap.set("x", lhs, lhs .. "gv", { desc = "Keep visually selected area when indenting" })
end

--- Module name to prefix vim.opt.keyset.keymap description
---@alias user.Keymap.module_prefix string

---@param module_prefix? user.Keymap.module_prefix
---@return vim.keymap.set.function
function M.init_mapping(module_prefix)
	return function(mode, lhs, rhs, opts)
		opts = opts or {}
		if module_prefix then
			opts.desc = ("%s: %s"):format(module_prefix, opts.desc or "")
		end

		return vim.keymap.set(mode, lhs, rhs, opts)
	end
end

--- Wrapper for |zz| (to scroll center) and |zv| (to open fold) keymaps
---@param rhs string Right-hand side |{rhs}| of the mapping
function M.scroll_center(rhs)
	vim.keymap.set("n", rhs, function()
		M.feedkeys(rhs)

		M.scroll_unfold()
	end, { desc = "Center the screen after " .. rhs })
end

function M.scroll_unfold()
	M.feedkeys("zzzv")
end

---@param direction "k"|"j" upwards or downwards
function M.vertical_move(direction)
	vim.keymap.set("n", direction, function()
		if vim.v.count > 0 and vim.v.count >= 3 then
			return "m'" .. vim.v.count .. direction
		else
			return "g" .. direction
		end
	end, {
		desc = "Move to " .. direction == "j" and "next" or "previous" .. " visual line",
		expr = true,
		noremap = true,
	})
end

---@param lhs "n"|"p" Left-hand side |{lhs}| of the mapping
function M.wild(lhs)
	local rhs = lhs == "n" and "down" or "up"

	vim.keymap.set("c", ("<C-%s>"):format(lhs), function()
		if vim.fn.wildmenumode() == 1 then
			return lhs
		else
			return ("<%s>"):format(rhs)
		end
	end, { desc = ("Navigate %s in wildmenu"):format(rhs), expr = true, silent = false })
end

return M
