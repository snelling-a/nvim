local M = {}

local IGNORE = {
	[[\v^(cquit!?|cq|q!?|Q|qa!?|Qa|bw)$]],
	[[\v^(w!?|W|wa!?|wq!?|wqa!?)$]],
	[[\v^[eE]$]],
	[[\v^(h(elp)?|his(t(ory)?)?)$]],
	[[\v^(Inspect(Tree)?|Mason|Remove|rest(art)?|Scratch|sor(t)?|tabc(lose)?)$]],
	[[\v^\d+$]],
}

---@param ignore_words string[]
local function clean(ignore_words)
	for _, value in ipairs(ignore_words) do
		vim.fn.histdel("cmd", value)
	end
end

function M.setup()
	vim.schedule(function()
		clean(IGNORE)
	end)
end

return M
