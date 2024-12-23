---@type LazySpec
return {
	"linrongbin16/gitlinker.nvim",
	cmd = { "GitLink" },
	keys = {
		{ "<leader>gl", mode = { "n", "v" }, desc = "GitLink: Yank git line" },
		{ "<leader>gB", mode = { "n", "v" }, desc = "GitLink: Yank git blame link" },
	},
	config = function()
		local gitlinker = require("gitlinker")
		gitlinker.setup()

		local map = Config.keymap("GitLink")

		map({ "n", "v" }, "<leader>gl", gitlinker.link, { silent = true, noremap = true, desc = "Yank git permlink" })
		map({ "n", "v" }, "<leader>gB", function()
			gitlinker.link({ router_type = "blame" })
		end, { silent = true, noremap = true, desc = "Yank git blame link" })
	end,
}
