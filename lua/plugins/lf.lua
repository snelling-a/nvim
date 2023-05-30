local LF = { "lmburns/lf.nvim" }

LF.dependencies = { "nvim-lua/plenary.nvim", "akinsho/toggleterm.nvim" }

LF.lazy = false

function LF.config()
	vim.g.lf_netrw = 1

	require("lf").setup({
		default_actions = { ["<C-s>"] = "split" },
		border = "rounded",
		direction = "horizontal",
	})

	vim.keymap.set("n", "<leader>l", "<cmd>lua require('lf').start()<CR>", { noremap = true })
end

return LF
