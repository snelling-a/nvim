local Icons = require("config.ui.icons")
local Util = require("config.util")

local M = {}
_G.Status = M

--- @return {name:string, text:string, texthl:string}[]
function M.get_signs()
	local buf = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
	return vim.tbl_map(
		function(sign) return vim.fn.sign_getdefined(sign.name)[1] end,
		vim.fn.sign_getplaced(buf, {
			group = "*",
			lnum = vim.v.lnum,
		})[1].signs
	)
end

function M.get_line_numbers()
	local v
	if vim.v.virtnum > 0 then
		v = Icons.misc.wrap .. " "
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
		return Util.is_file() and ("%%#LineNr#%s"):format(Icons.fillchars.foldsep) or ""
	end
end

function M.column()
	local sign, git_sign
	for _, s in ipairs(M.get_signs()) do
		if s.name:find("GitSign") then
			-- HACK: breaking change in internal api https://github.com/lewis6991/gitsigns.nvim/pull/799
			s.text = Icons.gitsigns[s.name]

			git_sign = s
		else
			sign = s
		end
	end

	local components = {
		[[%C]],
		sign and ("%#" .. sign.texthl .. "#" .. sign.text .. "%*") or " ",
		M.get_line_numbers(),
		M.get_gitsign(git_sign),
	}

	return table.concat(components, "")
end

vim.api.nvim_create_autocmd({
	"BufEnter",
}, {
	group = Util.augroup("Statuscolumn"),
	callback = function()
		if Util.is_file() then
			vim.opt_local.statusline = [[%!v:lua.Status.column()]]
		else
			vim.opt_local.statuscolumn = [[]]
		end
	end,
})
vim.opt.statuscolumn = [[%!v:lua.Status.column()]]

return M
