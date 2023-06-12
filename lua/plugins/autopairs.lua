local Autopairs = { "windwp/nvim-autopairs" }

Autopairs.opts = { check_ts = true }

Autopairs.event = "InsertEnter"

function Autopairs.config(_, opts)
	local autopairs = require("nvim-autopairs")

	autopairs.setup(opts)

	local cmp_autopairs = require("nvim-autopairs.completion.cmp")

	---@diagnostic disable-next-line: undefined-field
	require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done({}))
end

return Autopairs
