vim.pack.add({ "https://github.com/ibhagwan/fzf-lua" }, {
	load = function()
		vim.cmd.packadd("fzf-lua")
		local actions = require("fzf-lua.actions")
		require("fzf-lua").setup({
			"max-perf",
			lsp = { symbols = { symbol_style = 3 } },
			keymap = {
				fzf = { true, ["ctrl-q"] = "select-all+accept" },
			},
			helptags = {
				actions = { ["enter"] = actions.help_vert },
			},
		})

		FzfLua.register_ui_select()

		vim.keymap.set({ "n" }, "<leader>ff", FzfLua.files, { desc = "FzfLua files" })
		vim.keymap.set({ "n" }, "<leader>fg", FzfLua.live_grep, { desc = "FzfLua live grep" })
		vim.keymap.set({ "n" }, "<leader>fh", FzfLua.helptags, { desc = "FzfLua help" })
		vim.keymap.set({ "n" }, "<leader>fk", FzfLua.keymaps, { desc = "FzfLua keymaps" })
		vim.keymap.set({ "n" }, "<leader>fw", FzfLua.grep_cword, { desc = "FzfLua grep for current word" })
		vim.keymap.set({ "n" }, "<leader>.", FzfLua.resume, { desc = "FzfLua resume" })
	end,
})
