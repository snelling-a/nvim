local icons = require("config.ui.icons").misc

local M = {}
_G.Status = M

---@return {name:string, text:string, texthl:string}[]
function M.get_signs()
	local buf = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
	return vim.tbl_map(
		function(sign) return vim.fn.sign_getdefined(sign.name)[1] end,
		vim.fn.sign_getplaced(buf, { group = "*", lnum = vim.v.lnum })[1].signs
	)
end

function M.get_line_numbers()
	local v
	if vim.v.virtnum > 0 then
		v = icons.wrap .. " "
	elseif vim.v.virtnum < 0 then
		v = " "
	else
		v = [[%{&nu?(&rnu&&v:relnum?v:relnum:v:lnum):''} ]]
	end
	return "%=" .. v
end

function M.get_gitsign(git_sign)
	if git_sign then
		return "%#" .. git_sign.texthl .. "#" .. string.gsub(git_sign.text, "%s+", "") .. "%*"
	else
		return ""
	end
end

function M.column()
	local sign, git_sign
	for _, s in ipairs(M.get_signs()) do
		if s.name:find("GitSign") then
			git_sign = s
		else
			sign = s
		end
	end
	local components = {
		M.get_gitsign(git_sign),
		[[%C]],
		sign and ("%#" .. sign.texthl .. "#" .. sign.text .. "%*") or " ",
		M.get_line_numbers(),
	}
	return table.concat(components, "")
end

vim.opt.statuscolumn = [[%!v:lua.Status.column()]]

return M
