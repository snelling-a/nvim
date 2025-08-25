local Icons = require("icons")

---@class user.qf.statuscolumn
return function()
	---@type qflist
	local list = vim.fn.getloclist(vim.api.nvim_get_current_win(), { items = 0 })
	local item = list.items[vim.v.lnum]
	local components = { "", "%l", Icons.fillchars.vert }
	local icon = item and item.type and Icons.qf.type_mapping[item.type]

	if icon then
		components[1] = "%#" .. icon.hl .. "# " .. icon.text .. " %*"
	end

	return table.concat(components)
end
