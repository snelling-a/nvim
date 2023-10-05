--- @type LazySpec
local M = {
	"windwp/nvim-autopairs",
}

M.opts = {
	check_ts = true,
}

M.event = {
	"InsertEnter",
}

function M.config(_, opts)
	local autopairs = require("nvim-autopairs")

	autopairs.setup(opts)

	if require("config.util").is_vim() then
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")

		require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done({}))
	end
end

return M
