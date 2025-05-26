---@type LazySpec
return {
	"CopilotC-Nvim/CopilotChat.nvim",
	branch = "main",
	cmd = { "CopilotChat" },
	dependencies = {
		{ "zbirenbaum/copilot.lua" },
		{ "nvim-lua/plenary.nvim", branch = "master" },
	},
	keys = {
		{ "<leader>aa", desc = "CopilotChat: toggle", mode = { "n", "v" } },
		{ "<leader>ap", desc = "CopilotChat: prompt actions", mode = { "n", "v" } },
		{ "<leader>aq", desc = "CopilotChat: quick chat", mode = { "n", "v" } },
	},
	config = function()
		local chat = require("CopilotChat")

		vim.api.nvim_create_autocmd({ "BufEnter" }, {
			callback = function()
				vim.opt_local.relativenumber = false
				vim.opt_local.number = false
				vim.opt_local.list = false
				vim.opt_local.spell = false
				vim.opt_local.wrap = true
			end,
			pattern = "copilot-chat",
			group = vim.api.nvim_create_augroup("CopilotChat", {}),
		})

		-- local header_format = "%s  %s "

		chat.setup({
			auto_insert_mode = true,
			-- question_header = header_format:format(Config.icons.misc.user, "You"),
			-- answer_header = header_format:format(Config.icons.servers.copilot, "Copilot"),
			window = { width = 0.4 },
		})

		local map = require("user.keymap.util").map("CopilotChat")

		map({ "n", "v" }, "<leader>aa", chat.toggle, { desc = "toggle" })
		map({ "n", "v" }, "<leader>ap", chat.select_prompt, { desc = "prompt" })
		map({ "n", "v" }, "<leader>aq", function()
			local input = vim.fn.input("Quick Chat: ")
			if input ~= "" then
				chat.ask(input)
			end
		end, { desc = "quick" })
		map({ "n", "v" }, "<leader>ax", chat.reset, { desc = "clear" })
	end,
}
