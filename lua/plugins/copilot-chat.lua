---@type LazySpec
return {
	"CopilotC-Nvim/CopilotChat.nvim",
	branch = "main",
	cmd = { "CopilotChat" },
	keys = {
		{ "<leader>aa", desc = "CopilotChat: toggle", mode = { "n", "v" } },
		{ "<leader>ap", desc = "CopilotChat: prompt actions", mode = { "n", "v" } },
		{ "<leader>aq", desc = "CopilotChat: quick chat", mode = { "n", "v" } },
	},
	config = function()
		local chat = require("CopilotChat")

		Config.autocmd.create_autocmd({ "BufEnter" }, {
			callback = function()
				vim.opt_local.relativenumber = false
				vim.opt_local.number = false
				vim.opt_local.list = false
				vim.opt_local.spell = false
			end,
			pattern = "copilot-chat",
			group = "CopilotChat",
		})

		local header_format = "%s  %s "

		chat.setup({
			auto_insert_mode = true,
			question_header = header_format:format(Config.icons.misc.user, "You"),
			answer_header = header_format:format(Config.icons.servers.copilot, "Copilot"),
			window = { width = 0.4 },
		})

		local map = Config.keymap("CopilotChat")

		map({ "n", "v" }, "<leader>aa", chat.toggle, { desc = "toggle" })
		map({ "n", "v" }, "<leader>ap", function()
			local actions = require("CopilotChat.actions")
			require("CopilotChat.integrations.fzflua").pick(actions.prompt_actions())
		end, { desc = "prompt" })
		map({ "n", "v" }, "<leader>aq", function()
			local input = vim.fn.input("Quick Chat: ")
			if input ~= "" then
				chat.ask(input)
			end
		end, { desc = "quick" })
		map({ "n", "v" }, "<leader>ax", chat.reset, { desc = "clear" })
	end,
}
